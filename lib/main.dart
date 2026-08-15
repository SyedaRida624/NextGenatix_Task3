import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const TodoApp(),
    ),
  );
}

// 1. Task Model
class Task {
  String id;
  String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }
}

// 2. Provider for CRUD State Management
class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  int get completedCount => _tasks.where((t) => t.isCompleted).length;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _tasks.add(Task(id: DateTime.now().toString(), title: title.trim()));
    notifyListeners();
  }

  void editTask(String id, String newTitle) {
    if (newTitle.trim().isEmpty) return;
    final task = _tasks.firstWhere((t) => t.id == id);
    task.title = newTitle.trim();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.toggleCompleted();
    notifyListeners();
  }
}

// 3. Root Widget with Modern Purple/Indigo Theme
class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextGen To-Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFF8B5CF6),
        ),
        fontFamily: 'Roboto',
      ),
      home: const TodoListScreen(),
    );
  }
}

// 4. Main To-Do List Screen
class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  void _showTaskBottomSheet(BuildContext context, {Task? task}) {
    final controller = TextEditingController(text: task?.title ?? '');
    final isEditing = task != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isEditing ? 'Edit Task' : 'Create New Task',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(fontSize: 16, color: Color(0xFF334155)),
              decoration: InputDecoration(
                hintText: 'What needs to be done?',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    if (isEditing) {
                      Provider.of<TaskProvider>(context, listen: false)
                          .editTask(task.id, controller.text);
                    } else {
                      Provider.of<TaskProvider>(context, listen: false)
                          .addTask(controller.text);
                    }
                    Navigator.pop(ctx);
                  }
                },
                child: Text(
                  isEditing ? 'Save Changes' : 'Add Task',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final totalTasks = taskProvider.tasks.length;
            final completedTasks = taskProvider.completedCount;

            return CustomScrollView(
              slivers: [
                // Top Header Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withAlpha((0.3 * 255).round()),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Dashboard',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Task Tracker',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildHeaderStat('Total Tasks', '$totalTasks'),
                            _buildHeaderStat('Completed', '$completedTasks'),
                            _buildHeaderStat(
                              'Progress',
                              totalTasks == 0
                                  ? '0%'
                                  : '${((completedTasks / totalTasks) * 100).toInt()}%',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Task List Section Header
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Text(
                      'Recent Tasks',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),

                // Empty State or Task List
                if (taskProvider.tasks.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 72,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'All clear for now!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final task = taskProvider.tasks[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha((0.03 * 255).round()),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              leading: GestureDetector(
                                onTap: () => taskProvider
                                    .toggleTaskCompletion(task.id),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: task.isCompleted
                                        ? const Color(0xFF10B981)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: task.isCompleted
                                          ? const Color(0xFF10B981)
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: task.isCompleted
                                      ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                      : null,
                                ),
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: task.isCompleted
                                      ? Colors.grey.shade400
                                      : const Color(0xFF334155),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20, color: Color(0xFF6366F1)),
                                    onPressed: () => _showTaskBottomSheet(
                                        context,
                                        task: task),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        size: 20, color: Color(0xFFEF4444)),
                                    onPressed: () =>
                                        taskProvider.deleteTask(task.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: taskProvider.tasks.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withAlpha((0.35 * 255).round()),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: const Color(0xFF6366F1),
          onPressed: () => _showTaskBottomSheet(context),
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'New Task',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildHeaderStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}