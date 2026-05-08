# Flutter + Firebase / Supabase – Technical Assignment

**Role:** Flutter Developer

**Experience Required:** Minimum **3 years**

**Time Limit:** **3 days (strict)**

This assignment evaluates **core Flutter fundamentals**, backend integration, and the ability to ship a real Android build.

---

## 🎯 Objective

Build a **simple Notes application** using **Flutter** and either **Firebase** or **Supabase** that demonstrates:

- Authentication
- Secure CRUD operations
- Basic UI & state management
- Ability to deliver a working Android APK

---

## 🚨 Mandatory Submission Requirements (Read Carefully)

Your submission **will not be reviewed** if **any** of the following are missing:

1. **APK file**
    - Debug or release build is acceptable
    - Must be installable on a real Android device or emulator
2. **Public GitHub repository**
    - Repository must be **public**
    - Code must be complete and runnable
    - A proper `README.md` is mandatory (details below)

❌ **No APK = Automatic rejection**

❌ **Private repository = Automatic rejection**

---

## 🛠 Tech Stack (Mandatory)

- **Flutter**
- **Firebase OR Supabase** (Authentication + Database)
- Android build (APK)

> Do not use any other backend services.
> 

---

## 🔐 Features to Implement

### 1. Authentication

- Sign up using **email & password**
- Log in
- Log out
- User session must **persist after app restart**

> If the user is logged in and reopens the app, they should stay logged in.
> 

---

### 2. Notes Management (CRUD)

Each note must contain:

- `id`
- `title`
- `content`
- `created_at`
- `updated_at`
- `user_id`

### Required Operations:

- Create a note
- Edit a note
- Delete a note
- View a list of notes

🔒 **Important:**

A user must only be able to access **their own notes**.

If notes are visible across users, the submission will be rejected.

---

## 🧠 Additional Requirement (Choose ONE)

Implement **one** of the following:

### **Option A – Offline Handling**

- App should not crash when offline
- Show a basic offline or error state when data cannot be fetched

**OR**

### **Option B – Search Notes**

- Search notes by title
- Client-side search is acceptable

> Choose only one option.
> 

---

## 🎨 UI Expectations

This is **not a design-focused assignment**, but the UI must be:

- Clean and readable
- Properly laid out
- Free from broken widgets or overflow issues
- Usable without confusion

🚫 Extremely rough or tutorial-style UIs may be rejected.

---

## 📄 README.md Requirements (Mandatory)

Your GitHub repository **must** include a `README.md` that explains:

- Project setup steps
- How to run the app locally
- Database schema / collections / tables
- Authentication approach used
- Any assumptions or trade-offs made

---

## 🚫 Restrictions

- ❌ No Flutter Web-only submissions
- ❌ No screenshots instead of APK
- ❌ No private repositories
- ❌ No backend other than Firebase or Supabase

---

## ⏱ Timeline

- **3 days** from the time the assignment is shared
- Late submissions may not be reviewed

---

## ✅ Evaluation Criteria

We will evaluate based on:

- App stability
- Correct authentication implementation
- Secure CRUD operations
- Code structure & readability
- Proper backend usage
- Ability to ship a working APK

This assignment is intentionally **simple**.

Clean execution matters more than additional features.

---

### 📤 Submission Instructions

Share:

1. **APK file**
2. **Public GitHub repository link**

---

If you cannot meet the requirements within the given timeline, please do not submit.