import 'package:flutter/material.dart';
import 'task_manager.dart';
import 'task.dart';
import 'task_dialog.dart';
import 'search_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskManager taskManager = TaskManager();
  Set<int> selectedTaskIndices = {}; // Set to store selected task indices
  bool showAllTasks = true; // Flag to toggle between showing all tasks and filtered tasks

  @override
  void initState() {
    super.initState();
    taskManager.loadTaskData().then((_) {
      setState(() {}); // Ensure the widget rebuilds after loading data
    });
  }

  void deleteTask() {
    setState(() {
      // If showing all tasks, delete from the main list
      if (showAllTasks) {
        selectedTaskIndices.toList().sort((a, b) => b.compareTo(a));
        for (var index in selectedTaskIndices) {
          taskManager.deleteTask(index);
        }
      } else {
        // If showing filtered tasks, delete from the filtered list and the main list
        final List<Task> filteredTasks = taskManager.filteredTasks;
        selectedTaskIndices.toList().sort((a, b) => b.compareTo(a));
        for (var index in selectedTaskIndices) {
          Task task = filteredTasks[index];
          int mainIndex = taskManager.tasks.indexOf(task);
          taskManager.deleteTask(mainIndex);
        }
      }
      selectedTaskIndices.clear();
    });
  }

  void editTask() {
    if (selectedTaskIndices.length == 1) {
      int index = selectedTaskIndices.first;
      Task task = showAllTasks ? taskManager.tasks[index] : taskManager.filteredTasks[index];
      showDialog(
        context: context,
        builder: (context) => TaskDialog(
          task: task,
          onSave: (editedTask) {
            setState(() {
              if (showAllTasks) {
                taskManager.updateTask(index, editedTask);
              } else {
                // If showing filtered tasks, update the task in both the filtered list and the main list
                int mainIndex = taskManager.tasks.indexOf(task);
                taskManager.updateTask(mainIndex, editedTask);
              }
            });
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  void addTask() {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        onSave: (task) {
          setState(() {
            taskManager.addTask(task);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void searchTasks(String query) {
    setState(() {
      if (query.isEmpty) {
        taskManager.showAllTasks(); // Reset filtering if query is empty
        showAllTasks = true; // Show all tasks
      } else {
        taskManager.filterTasks(query);
        showAllTasks = false; // Show filtered tasks
      }
    });
  }

  void showAll() {
    setState(() {
      taskManager.showAllTasks();
      showAllTasks = true; // Show all tasks when "Show All" button is clicked
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Task> tasksToShow = showAllTasks ? taskManager.tasks : taskManager.filteredTasks;

    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Center(child: Text(widget.title))),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SearchDialog(
                    onSearch: searchTasks,
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: showAll,
            ),
            if (selectedTaskIndices.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: deleteTask,
              ),
            if (selectedTaskIndices.length == 1)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: editTask,
              ),
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: tasksToShow.length,
        itemBuilder: (context, index) {
          final task = tasksToShow[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Card(
              color: selectedTaskIndices.contains(index) ? Colors.grey : Colors.pink[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Checkbox(
                  value: selectedTaskIndices.contains(index),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedTaskIndices.add(index);
                      } else {
                        selectedTaskIndices.remove(index);
                      }
                    });
                  },
                ),
                title: Text(
                  task.name,
                  style: const TextStyle(fontSize: 20),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Finish Date: ${task.date}', style: const TextStyle(fontSize: 14)),
                    Text('Finish Time: ${task.time}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Task'),
        onPressed: addTask,
      ),
    );
  }
}