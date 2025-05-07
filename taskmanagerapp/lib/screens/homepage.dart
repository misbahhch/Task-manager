import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedTasks = prefs.getStringList('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks = savedTasks.map((taskString) {
          List<String> parts = taskString.split(',');
          return Task(title: parts[0], isComplete: parts[1] == 'true');
        }).toList();
      });
    }
  }

  _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => '${task.title},${task.isComplete}').toList();
    prefs.setStringList('tasks', taskList);
  }

  _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        tasks.add(Task(title: _taskController.text.trim()));
        _taskController.clear();
      });
      _saveTasks();
    }
  }

  _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    _saveTasks();
  }

  _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isComplete = !tasks[index].isComplete;
    });
    _saveTasks();
  }

  _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Add Task"),
        content: TextField(
          controller: _taskController,
          decoration: InputDecoration(
            hintText: 'Enter your task here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addTask();
              Navigator.of(context).pop();
            },
            child: Text("Add", style: TextStyle(color: Colors.teal)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('📝 Task Manager', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 2,
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        tasks[index].isComplete
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: tasks[index].isComplete ? Colors.teal : Colors.grey,
                      ),
                      onPressed: () => _toggleTaskCompletion(index),
                    ),
                    title: Text(
                      tasks[index].title,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: tasks[index].isComplete ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteTask(index),
                    ),
                    onTap: () => _toggleTaskCompletion(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, size: 30),
        tooltip: 'Add Task',
      ),
    );
  }
}
