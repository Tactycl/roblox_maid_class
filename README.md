# Roblox Maid Class

This class is to clean up pointless objects & more easily.

# API

.new(), returns (Maid) -> Creates a new maid object<br/>
:GiveTask(job: Task), returns (job: Task, task_id: number) -> Gives a task to cleanup later to the maid, a Task can be: RBXScriptConnection, any function, any object with a Destroy or Disconnect method<br/>
:Cleanup(), returns none -> Cleans all given tasks<br/>
:Clean(task_id: number), returns none -> Cleans a specific task given by using the task_id<br/>
:CleanupDeferred(job: Task, delayTime: number), returns none -> Cleans the task given after the specified amount of time<br/>
:Size(), returns (size: number) -> Returns the amount of Tasks<br/>
:IsEmpty(), returns (empty: boolean) -> Returns true if maid has no tasks given to it<br/>
:Destroy() -> Clears up maid by calling :Cleanup() on itself and clearing itself<br/>
