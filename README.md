# Week 3: Task Tracker - CRUD Operations & State Management

A modern Flutter To-Do application built to master local CRUD (Create, Read, Update, Delete) operations and reactive state management using **Provider**.

---

## 🎯 Project Objective
Learn and implement local data manipulation in Flutter by creating an interactive Task Tracker application.

### Key Objectives Achieved:
* **Create**: Add new tasks via a bottom sheet modal.
* **Read**: Render dynamic task lists efficiently using `ListView.builder`.
* **Update**: Edit existing task details and toggle completion status.
* **Delete**: Remove tasks with instant dashboard metric updates.
* **State Management**: Refactored architecture from `setState()` to **Provider** (`ChangeNotifier`).

---

---

## 📸 Screenshots & Workflow Walkthrough

### 1. Dashboard Initial State
When the app launches with no tasks, the dashboard initializes metrics to `0` and displays a clean, empty-state placeholder.

<img width="1035" height="620" alt="ng3 1" src="https://github.com/user-attachments/assets/32a11117-3c23-4c41-8667-3d47264310fe" />


---

### 2. Add New Task (Create)
Clicking **+ New Task** opens a modal bottom sheet to input a new item.

<img width="723" height="284" alt="ng3 2" src="https://github.com/user-attachments/assets/4018d8cc-cbc0-4384-8986-def084e7fe49" />

---

### 3. Task List View (Read)
Newly created tasks appear in the list using `ListView.builder`, automatically updating the **Total Tasks** metric on the dashboard.

<img width="1033" height="702" alt="ng3 3" src="https://github.com/user-attachments/assets/f24859bb-6513-4517-a26d-d483ca37090c" />

---

### 4. Edit Task (Update - Title)
Tapping the edit (pencil) icon opens the modal pre-filled with the current title for quick editing.

<img width="687" height="282" alt="ng3 4" src="https://github.com/user-attachments/assets/15b05254-5f49-4a98-97df-bb5a9a1a66fa" />

---

### 5. Updated Task State
Saving changes immediately refreshes the UI state without needing a full screen reload.

<img width="1036" height="623" alt="ng3 5" src="https://github.com/user-attachments/assets/e78a8b66-6d96-4746-b089-963b50b741be" />

---

### 6. Mark as Completed (Update - Status)
Toggling the radio/check button marks tasks complete, applies a strikethrough effect, and updates the **Progress** percentage to `100%`.

<img width="1031" height="619" alt="ng3 6" src="https://github.com/user-attachments/assets/2c92c83b-f188-4da3-a46a-1f19f6dcc196" />

---

### 7. Delete Task (Delete)
Tapping the delete (trash) icon removes the item from the list and recalculates the dashboard stats instantly.

<img width="1034" height="629" alt="ng3 7" src="https://github.com/user-attachments/assets/21a5c9ce-edbe-4c46-8e5e-693707580cae" />


---
