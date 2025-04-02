# xui_users_combine

**xui_users_combine** is a tool that combines multiple users using the same port on multiple XUI panels into a single panel entry. This simplifies user management and avoids clutter when using shared ports.

## 🚀 What It Does

When users are added with the same port on different XUI panels, this tool merges them into one inbound entry on a central server.

## 📁 File Structure

- `.hrn` files (renamed from `.php` for security)
- `xapi.sh`: Bash script for backend logic (run this on the new central server)
- `index.html`: UI interface to submit user data
- Serves the dashboard on port **8080**

## 📌 Why `.hrn` Instead of `.php`?

To avoid PHP code being executed automatically if someone hosts the project publicly. Rename them back to `.php` if you're running this in a safe environment.

## 🧠 Centralized Usage

This is designed for **centralized management**.

- Run `xapi.sh` on a dedicated server.
- Host the UI (from `index.html`) on the same server.
- Server listens on **port 8080**.

### 🛠️ Setup Instructions

```bash
git clone https://github.com/hossein75rn/xui_users_combine.git
cd xui_users_combine/xui/v1/panels
chmod +x xapi.sh
./xapi.sh
```

Access via: `http://your-server-ip:8080`

## 🧪 How to Use

1. On your XUI panel, create an inbound with the port you want (e.g. 2095).
2. Note the **Inbound ID**.
3. Go to the dashboard hosted on the new server (port 8080).
4. Fill in the form as follows:

| Field | Description |
|-------|-------------|
| 1️⃣ | Username of the new server's panel |
| 2️⃣ | Password of the panel |
| 3️⃣ | Server suffix name (e.g., `server1`, becomes `hossein server1`) – *required for duplicates* |
| 4️⃣ | Inbound ID |
| 5️⃣ | Export inbound JSON from the old panel and paste it here |

5. Click **Submit**. Users will be added to the central panel on the same port.

## 🙋‍♂️ Contributions

Pull requests are welcome!

## 📜 License

Licensed under the [MIT License](LICENSE).

## 👤 Author

Created by [@hossein75rn](https://github.com/hossein75rn)