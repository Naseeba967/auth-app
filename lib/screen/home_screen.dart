import 'package:developer_hub_authentication_app/screen/login_screen.dart';
import 'package:developer_hub_authentication_app/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TaskService _taskService = TaskService();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Task> _tasks = [];
  bool _isLoading = true;
 late final  FirebaseAuthService _firebaseAuthService;
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskService.loadTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }
// inside your State class
Future<void> _logout() async {
  try {
    await FirebaseAuthService().logout;

    // if this State is unmounted after async, stop
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Signed out successfully"),
        duration: Duration(seconds: 1),
      ),
    );

    // remove all previous routes and go to LoginScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );

    // OR if you use named routes:
    // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

  } catch (e, st) {
    // show error and log
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sign out failed: ${e.toString()}")),
    );
    // optional: print or use logger
    print('Sign out error: $e\n$st');
  }
}

  void _showAddTaskSheet() {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  return AnimatedPadding(
    duration: const Duration(milliseconds: 150),
    padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.add_task_rounded,
                          color: colorScheme.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add New Task',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: controller,
                    autofocus: true,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      
                      hintText: 'What needs to be done?',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.edit_outlined, color: Colors.grey[400]),
                      filled: true,
                    
                      focusColor: colorScheme.primary,
                      fillColor: Colors.grey[50],
                      // hoverColor: colorScheme.primary,
                      border: OutlineInputBorder(
                    
                        borderRadius: BorderRadius.circular(16),
                        
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(16),
                        borderSide:  BorderSide(color: colorScheme.primary, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a task';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _addTask(formKey, controller, context),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => _addTask(formKey, controller, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add Task',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addTask(GlobalKey<FormState> formKey,
      TextEditingController controller, BuildContext sheetContext) async {
    if (formKey.currentState!.validate()) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: controller.text.trim(),
      );

      setState(() {
        _tasks.add(newTask);
      });

      if (_listKey.currentState != null) {
        _listKey.currentState!.insertItem(
          _tasks.length - 1,
          duration: const Duration(milliseconds: 300),
        );
      }

      await _taskService.saveTasks(_tasks);

      if (sheetContext.mounted) {
        Navigator.of(sheetContext).pop();
      }
    }
  }

  Future<void> _toggleTaskCompletion(String taskId) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      setState(() {
        _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      });
      await _taskService.saveTasks(_tasks);
    }
  }

  Future<void> _deleteTask(int index, Task task) async {
    final removedTask = _tasks.removeAt(index);
    
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildAnimatedTaskCard(removedTask, animation, index),
      duration: const Duration(milliseconds: 300),
    );

    setState(() {});

    await _taskService.saveTasks(_tasks);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Task deleted'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.checklist_rounded, size: 28),
            const SizedBox(width: 10),
            Text(
              'Task Manager',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _showAddTaskSheet,
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_rounded, size: 22),
              ),
              tooltip: 'Add Task',
            ),
          ), 
            Padding(
    padding: const EdgeInsets.only(right: 12),
    child: IconButton(
      onPressed: () => _logout(),
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.logout_rounded, size: 22),
      ),
      tooltip: 'Sign Out',
    ),
  ),
          
          
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            )
          : _tasks.isEmpty
              ? _buildEmptyState()
              : _buildAnimatedTaskList(),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 64,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No Tasks Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start by adding your first task.\nTap the + button above to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showAddTaskSheet,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Your First Task'),
              style: ElevatedButton.styleFrom(
                backgroundColor:colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTaskList() {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _tasks.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index, animation) {
        if (index >= _tasks.length) return const SizedBox.shrink();
        final task = _tasks[index];
        return _buildAnimatedTaskCard(task, animation, index);
      },
    );
  }

  Widget _buildAnimatedTaskCard(Task task, Animation<double> animation, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: animation,
        child: _buildTaskCard(task, index),
      ),
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(
        begin: 1.0,
        end: task.isCompleted ? 0.7 : 1.0,
      ),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        tween: Tween<double>(
          begin: 1.0,
          end: task.isCompleted ? 0.98 : 1.0,
        ),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: task.isCompleted ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: task.isCompleted
                  ? Colors.transparent
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _toggleTaskCompletion(task.id),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: task.isCompleted ? Colors.green : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted ? Colors.green : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: task.isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            size: 18,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.grey[400],
                        decorationThickness: 2,
                        color: task.isCompleted ? Colors.grey[400] : Colors.black87,
                      ),
                      child: Text(task.title),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: IconButton(
                      onPressed: () => _deleteTask(index, task),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red[300],
                        size: 22,
                      ),
                      tooltip: 'Delete Task',
                      splashRadius: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
