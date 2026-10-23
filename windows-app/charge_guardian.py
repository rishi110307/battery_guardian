import sys
import tkinter as tk
from tkinter import messagebox
try:
    import psutil
except ImportError:
    psutil = None

APP_NAME = "100% Charge Guardian"
POLL_MS = 30_000

class ChargeGuardian:
    def __init__(self, root):
        self.root = root
        self.root.title(APP_NAME)
        self.root.geometry("460x360")
        self.root.minsize(380, 300)
        self.root.configure(bg="#101827")
        self.threshold = tk.IntVar(value=15)
        self.last_full_notice = False
        self.warning = None
        self.status = tk.StringVar(value="Starting battery monitor…")
        tk.Label(root, text="100% CHARGE GUARDIAN", font=("Segoe UI", 16, "bold"),
                 fg="#ffffff", bg="#101827").pack(pady=(18, 6))
        tk.Label(root, text="Keep an eye on your battery", font=("Segoe UI", 10),
                 fg="#b9c6d8", bg="#101827").pack()
        self.percent_label = tk.Label(root, text="--%", font=("Segoe UI", 38, "bold"),
                                      fg="#55e6a5", bg="#101827")
        self.percent_label.pack(pady=10)
        self.status_label = tk.Label(root, textvariable=self.status, wraplength=400,
                                     font=("Segoe UI", 10), fg="#e8eef8", bg="#101827")
        self.status_label.pack(pady=5)
        row = tk.Frame(root, bg="#101827")
        row.pack(pady=10)
        tk.Label(row, text="Low battery threshold:", fg="#e8eef8", bg="#101827").pack(side="left", padx=5)
        tk.Spinbox(row, from_=5, to=30, width=5, textvariable=self.threshold).pack(side="left")
        tk.Button(root, text="Check now", command=self.check_battery,
                  bg="#2d74da", fg="white", relief="flat", padx=16, pady=8).pack(pady=8)
        tk.Label(root, text="A warning can be dismissed. This app does not lock your device.",
                 font=("Segoe UI", 8), fg="#9aa9bf", bg="#101827", wraplength=410).pack(pady=8)
        self.check_battery()

    def notify(self, title, message):
        # Use Windows toast notifications if winotify is installed; otherwise use a dialog.
        try:
            from winotify import Notification
            Notification(app_id=APP_NAME, title=title, msg=message).show()
        except Exception:
            try:
                self.root.bell()
                messagebox.showinfo(title, message, parent=self.root)
            except Exception:
                pass

    def show_warning(self, percent):
        if self.warning and self.warning.winfo_exists():
            self.warning_label.configure(text=f"Battery is at {percent}%.\nPlease connect your charger to continue.")
            return
        self.warning = tk.Toplevel(self.root)
        self.warning.title("Low battery")
        self.warning.configure(bg="#721c24")
        self.warning.attributes("-topmost", True)
        try:
            self.warning.attributes("-fullscreen", True)
        except tk.TclError:
            self.warning.geometry("800x500")
        self.warning_label = tk.Label(
            self.warning,
            text=f"BATTERY BELOW {self.threshold.get()}%\n\nBattery is at {percent}%.\nPlease connect your charger.",
            font=("Segoe UI", 26, "bold"), fg="white", bg="#721c24",
            justify="center", wraplength=900
        )
        self.warning_label.pack(expand=True, fill="both", padx=30, pady=30)
        tk.Button(self.warning, text="I will connect the charger", font=("Segoe UI", 14),
                  command=self.warning.destroy, padx=18, pady=10).pack(pady=25)

    def check_battery(self):
        if psutil is None:
            self.status.set("Install dependencies: python -m pip install -r requirements.txt")
            self.root.after(POLL_MS, self.check_battery)
            return
        try:
            battery = psutil.sensors_battery()
            if battery is None:
                self.percent_label.configure(text="N/A", fg="#ffcc66")
                self.status.set("Battery information is not available on this device.")
            else:
                pct = int(round(battery.percent))
                plugged = bool(battery.power_plugged)
                self.percent_label.configure(text=f"{pct}%", fg="#55e6a5" if pct >= self.threshold.get() else "#ff7676")
                self.status.set("Charger connected" if plugged else "Running on battery power")
                if pct >= 100 and plugged:
                    if not self.last_full_notice:
                        self.notify("Battery fully charged", "Your battery has reached 100%.")
                        self.last_full_notice = True
                else:
                    self.last_full_notice = False
                if pct < self.threshold.get() and not plugged:
                    self.show_warning(pct)
                elif self.warning and self.warning.winfo_exists():
                    self.warning.destroy()
                    self.warning = None
        except Exception as exc:
            self.status.set("Unable to read battery status: " + str(exc))
        self.root.after(POLL_MS, self.check_battery)

if __name__ == "__main__":
    root = tk.Tk()
    app = ChargeGuardian(root)
    root.mainloop()
