# Roblox Maid Class  

The **Maid Class** is a utility designed to **simplify cleanup and resource management** in Roblox. It allows developers to efficiently manage tasks such as connections, functions, and objects, ensuring proper cleanup to prevent memory leaks and unintended behavior.  

---

## Key Benefits  
- Centralized management of cleanup tasks.  
- Supports deferred cleanup for scheduled operations.  
- Reduces boilerplate and ensures consistent resource handling.  

---

## API Reference  

### Constructor  
- **`.new(): Maid`**  
  Creates a new Maid object.  

---

### Task Management  
- **`:GiveTask(job: Task): (job: Task, task_id: number)`**  
  Assigns a task to the Maid for future cleanup.  
  - **Task Types:** `RBXScriptConnection`, functions, or any object with a `Destroy` or `Disconnect` method.  

- **`:Cleanup()`**  
  Cleans up **all tasks** currently assigned to the Maid.  

- **`:Clean(task_id: number)`**  
  Cleans a **specific task** identified by `task_id`.  

- **`:CleanupDeferred(job: Task, delayTime: number)`**  
  Cleans the provided task **after a specified delay**.  

- **`:Size(): number`**  
  Returns the **number of tasks** currently managed by the Maid.  

- **`:IsEmpty(): boolean`**  
  Returns `true` if no tasks are assigned.  

- **`:Destroy()`**  
  Performs a **full cleanup** of the Maid object and clears internal references.  

---

## Example Usage  

```lua
local Maid = require(path.to.Maid)
local maid = Maid.new()

-- Add a connection for cleanup
local connection = game:GetService("RunService").Heartbeat:Connect(function()
    print("Tick")
end)
maid:GiveTask(connection)

-- Add a function
maid:GiveTask(function()
    print("Cleaning up custom function")
end)

-- Cleanup all tasks manually
maid:Cleanup()

-- Check if maid is empty
print(maid:IsEmpty()) -- true
```
