--!strict

export type Task = 
	RBXScriptConnection 
	| (any) -> (any)
	| { Destroy: (any) -> (any) } 
	| { Disconnect: (any) -> (any) }

export type Maid = {
	_tasks: {Task},
	
	new: () -> (Maid),
	GiveTask: (self: Maid, job: Task) -> (Task, number),
	Cleanup: (self: Maid) -> (),
	Clean: (self: Maid, task_id: number) -> (),
	CleanupDeferred: (self: Maid, job: Task, delayTime: number) -> (),
	Size: (self: Maid) -> (number),
	IsEmpty: (self: Maid) -> (boolean),
	Destroy: (self: Maid) -> (),
}

local Maid = {}
Maid.__index = Maid

-- PUBLIC

function Maid.new(): Maid
	local self = (setmetatable({}, Maid):: unknown):: Maid
	self._tasks = {}
	return self
end

function Maid:GiveTask(job: Task): (Task, number)
	local task_id = #self._tasks + 1
	self._tasks[task_id] = job

	return job, task_id
end

function Maid:Cleanup()
	for task_id in self._tasks do
		self:Clean(task_id)
	end
	
	table.clear(self._tasks)
end

function Maid:Clean(task_id: number)
	local job: Task = self._tasks[task_id]
	
	if typeof(job) == "RBXScriptConnection" then
		job:Disconnect()

	elseif typeof(job) == "function" then
		local success, errmsg = pcall(job)
		if not success then
			warn(string.format("[Maid] task_id %s failed to cleanup with error message '%s' (function call)", tostring(task_id), tostring(errmsg)))
		end
		
	elseif typeof(job) == "thread" then
		coroutine.close(job)

	elseif job.Destroy and typeof(job.Destroy) == "function" then
		local success, errmsg = pcall(job.Destroy, job)
		if not success then
			warn(string.format("[Maid] task_id %s failed to cleanup with error message '%s' (destroy call)", tostring(task_id), tostring(errmsg)))
		end
		
	elseif job.Disconnect and typeof(job.Disconnect) == "function" then
		local success, errmsg = pcall(job.Disconnect, job)
		if not success then
			warn(string.format("[Maid] task_id %s failed to cleanup with error message '%s' (disconnect call)", tostring(task_id), tostring(errmsg)))
		end
	end
	
	self._tasks[task_id] = nil
end

function Maid:CleanupDeferred(job: Task, delayTime: number)
	local task_id = self:GiveTask(job)
	task.delay(delayTime, function()
		self:Clean(task_id)
	end)
end

function Maid:Size(): number
	local count = 0
	for _ in self._tasks do
		count += 1
	end
	return count
end

function Maid:IsEmpty(): boolean
	return self:Size() == 0
end

function Maid:Destroy()
	self:Cleanup()
	table.clear(self)
end

return Maid
