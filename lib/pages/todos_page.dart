import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier_provider/pages/todos_provider.dart';

class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);
    print(todos);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Column(
        children: [
          const AddTodo(),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView(
              children: [
                for (final todo in todos)
                  CheckboxListTile.adaptive(
                    value: todo.completed,
                    onChanged: (value) {
                      ref.watch(todosProvider.notifier).toggleTodo(todo.id);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(todo.desc),
                    secondary: IconButton(
                      onPressed: () {
                        ref.watch(todosProvider.notifier).removeTodo(todo.id);
                      },
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _textController,
        decoration: const InputDecoration(
          hintText: 'Add Todo',
        ),
        onFieldSubmitted: (String desc) {
          if (desc.trim().isNotEmpty && desc.trim() != '') {
            ref.read(todosProvider.notifier).addTodo(desc);
            _textController.clear();
          }
        },
      ),
    );
  }
}
