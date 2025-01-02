Add Taskwarrior task before other task - basically a subtask

# Usage 
`$ task-add-before 1337 Do the thing that needs to be done before`
A new task will be created, and 1337 will depend on the new task. 

If Taskwarrior ever adds "subtasks", this will not be needed anymore

# Installation
- Have Taswarrior installed
- Copy `task-add-before` to anywhere on your `$PATH`

# Todo
- [ ] copy the tags and project of the parent
