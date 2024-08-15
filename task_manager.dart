import 'task.dart';

class TaskManager {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];

  // Load tasks from storage
  Future<void> loadTaskData() async {
    // Simulated task loading
    tasks = [/* your tasks here */];
  }

  void addTask(Task task) {
    tasks.add(task);
    // Optionally reapply the current filter if needed
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }

  void updateTask(int index, Task updatedTask) {
    tasks[index] = updatedTask;
  }

  void filterTasks(String query) {
    filteredTasks = tasks.where((task) =>
      task.name.toLowerCase().contains(query.toLowerCase()) ||
      task.date.contains(query)
    ).toList();
  }

  void showAllTasks() {
    filteredTasks = tasks;
  }
}
