from datetime import datetime, timezone
from typing import Literal
from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(title="Charge Guardian API", version="1.0.0")
events = []  # In-memory demo store; data resets when the server restarts.

class BatteryEvent(BaseModel):
    device: str = Field(min_length=1, max_length=100)
    battery_percent: int = Field(ge=0, le=100)
    charging: bool
    event: Literal["low_battery", "full_charge", "status"] = "status"

@app.get("/")
def root():
    return {"name": "100% Charge Guardian API", "docs": "/docs", "health": "/health"}

@app.get("/health")
def health():
    return {"ok": True, "utc": datetime.now(timezone.utc).isoformat()}

@app.post("/api/events")
def create_event(item: BatteryEvent):
    record = item.model_dump()
    record["received_at"] = datetime.now(timezone.utc).isoformat()
    events.append(record)
    if len(events) > 500:
        del events[:-500]
    return {"saved": True, "event": record}

@app.get("/api/events")
def list_events(limit: int = 50):
    limit = max(1, min(limit, 200))
    return {"count": min(len(events), limit), "events": list(reversed(events[-limit:]))}
