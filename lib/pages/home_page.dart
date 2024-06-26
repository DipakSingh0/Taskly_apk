// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:taskly/models/task.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<StatefulWidget> createState() {
//     return _HomePageState();
//   }
// }

// class _HomePageState extends State<HomePage> {
//   late double _deviceHeight;
//   String? _newTaskContent;
//   Box? _box;

//   @override
//   void initState() {
//     super.initState();
//     _openBox();
//   }

//   Future<void> _openBox() async {
//     _box = await Hive.openBox('tasks');
//     setState(() {}); // Trigger a rebuild once the box is opened
//   }

//   @override
//   Widget build(BuildContext context) {
//     _deviceHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//           toolbarHeight: _deviceHeight * 0.15,
//           backgroundColor: Colors.red,
//           title: const Text("Taskly",
//               style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white))),
//       body: _taskView(),
//       floatingActionButton: _addTaskButton(),
//     );
//   }

//   Widget _taskView() {
//     Hive.openBox('tasks');
//     return FutureBuilder(
//       future: Hive.openBox('tasks'),
//       builder: (BuildContext _context, AsyncSnapshot _snapshot) {
//         if (_snapshot.hasData) {
//           _box = _snapshot.data;
//           return _taskList();
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }

//   Widget _taskList() {
//     List tasks = _box!.values.toList();
//     if (tasks.isEmpty) {
//       return const Center(
//         child: Text('No tasks available'),
//       );
//     }
//     return ListView.builder(
//       itemCount: tasks.length,
//       itemBuilder: (BuildContext _context, int _index) {
//         var task = Task.fromMap(tasks[_index]); // Use actual task content
//         return ListTile(
//           title: Text(
//             task.content,
//             style: TextStyle(
//               decoration: task.done ? TextDecoration.lineThrough : null,
//             ),
//           ),
//           subtitle: Text(
//             // Format the timestamp to exclude seconds
//             "${task.timestamp.toLocal().toString().split(' ')[0]} ${TimeOfDay.fromDateTime(task.timestamp).format(context)}",
//           ),
//           trailing: Icon(
//             task.done
//                 ? Icons.check_box_outlined
//                 : Icons.check_box_outline_blank_outlined,
//             color: Colors.red,
//           ),
//           onTap: () {
//             task.done = !task.done;
//             _box!.putAt(
//               _index,
//               task.toMap(),
//             );
//             setState(() {});
//           },
//           onLongPress: () {
//             _box!.deleteAt(_index);
//             setState(() {});
//           },
//         );
//       },
//     );
//   }

//   Widget _addTaskButton() {
//     return FloatingActionButton(
//       onPressed: _displayTaskPopup,
//       child: const Icon(Icons.add),
//     );
//   }

//   void _displayTaskPopup() {
//     DateTime selectedDate = DateTime.now();
//     TimeOfDay selectedTime = TimeOfDay.now();

//     showDialog(
//       context: context,
//       builder: (BuildContext _context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               title: const Text("Add new task!"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     decoration:
//                         const InputDecoration(labelText: "Task Content"),
//                     onChanged: (_value) {
//                       _newTaskContent = _value;
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final DateTime? pickedDate = await showDatePicker(
//                         context: context,
//                         initialDate: selectedDate,
//                         firstDate: DateTime.now(),
//                         lastDate: DateTime(2101),
//                       );
//                       if (pickedDate != null && pickedDate != selectedDate) {
//                         setState(() {
//                           selectedDate = pickedDate;
//                         });
//                       }
//                     },
//                     child: const Text("Select Date"),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final TimeOfDay? pickedTime = await showTimePicker(
//                         context: context,
//                         initialTime: selectedTime,
//                       );
//                       if (pickedTime != null && pickedTime != selectedTime) {
//                         setState(() {
//                           selectedTime = pickedTime;
//                         });
//                       }
//                     },
//                     child: const Text("Select Time"),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     "Selected: ${selectedDate.toLocal().toString().split(' ')[0]} ${selectedTime.format(context)}",
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     if (_newTaskContent != null &&
//                         _newTaskContent!.isNotEmpty) {
//                       DateTime fullDateTime = DateTime(
//                         selectedDate.year,
//                         selectedDate.month,
//                         selectedDate.day,
//                         selectedTime.hour,
//                         selectedTime.minute,
//                       );
//                       var _task = Task(
//                         content: _newTaskContent!,
//                         timestamp: fullDateTime,
//                         done: false,
//                       );
//                       _box!.add(_task.toMap());
//                       setState(() {
//                         _newTaskContent = null;
//                         Navigator.pop(context);
//                       });
//                     }
//                   },
//                   child: const Text("Add Task"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskly/models/task.dart';
import 'package:taskly/pages/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late double _deviceHeight;
  String? _newTaskContent;
  Box? _box;

  final double maxSlide = 225.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _openBox();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _openBox() async {
    _box = await Hive.openBox('tasks');
    setState(() {}); // Trigger a rebuild once the box is opened
  }

  void toggleDrawer() => _animationController.isDismissed
      ? _animationController.forward()
      : _animationController.reverse();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        backgroundColor: Colors.blue,
        title: const Text(
          "Taskly",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
          ),
          onPressed: toggleDrawer,
        ),
      ),
      body: AnimatedDrawer(
        maxSlide: maxSlide,
        animationController: _animationController,
        child: _taskView(),
      ),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox('tasks'),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _taskList();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _taskList() {
    List tasks = _box!.values.toList();
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks available'),
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        var task = Task.fromMap(tasks[_index]); // Use actual task content
        return ListTile(
          title: Text(
            task.content,
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            // Format the timestamp to exclude seconds
            "${task.timestamp.toLocal().toString().split(' ')[0]} ${TimeOfDay.fromDateTime(task.timestamp).format(context)}",
          ),
          trailing: Icon(
            task.done
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_outlined,
            color: Colors.red,
          ),
          onTap: () {
            task.done = !task.done;
            _box!.putAt(
              _index,
              task.toMap(),
            );
            setState(() {});
          },
          onLongPress: () {
            _box!.deleteAt(_index);
            setState(() {});
          },
        );
      },
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _displayTaskPopup,
      child: const Icon(Icons.add),
    );
  }

  void _displayTaskPopup() {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Add new task!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(labelText: "Task Content"),
                    onChanged: (_value) {
                      _newTaskContent = _value;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text("Select Date"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (pickedTime != null && pickedTime != selectedTime) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: const Text("Select Time"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Selected: ${selectedDate.toLocal().toString().split(' ')[0]} ${selectedTime.format(context)}",
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (_newTaskContent != null &&
                        _newTaskContent!.isNotEmpty) {
                      DateTime fullDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                      var _task = Task(
                        content: _newTaskContent!,
                        timestamp: fullDateTime,
                        done: false,
                      );
                      _box!.add(_task.toMap());
                      setState(() {
                        _newTaskContent = null;
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text("Add Task", style: TextStyle(color: Colors.blue),),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class AnimatedDrawer extends StatelessWidget {
  final double maxSlide;
  final AnimationController animationController;
  final Widget child;

  const AnimatedDrawer({
    required this.maxSlide,
    required this.animationController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        double slide = maxSlide * animationController.value;
        double scale = 1 - (animationController.value * 0.3);

        return Stack(
          children: <Widget>[
            Container(
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  AnimatedOpacity(
                    opacity: animationController.value,
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      children: [
                        ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.white),
                          title: const Text('Profile',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => Profile_page() ,));
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.settings, color: Colors.white),
                          title: const Text('Settings',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            // Handle settings tap
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.info, color: Colors.white),
                          title: const Text('About',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            // Handle settings tap
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Transform(
              transform: Matrix4.identity()
                ..translate(slide)
                ..scale(scale),
              alignment: Alignment.centerLeft,
              child: Container(
                color: Colors.white,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
