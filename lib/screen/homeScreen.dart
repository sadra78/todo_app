import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Controller/taskController.dart';
import 'package:get/get.dart';
import 'package:todo_app/constants.dart';

import '../Model/Task.dart';
import 'package:progress_indicator_button/progress_button.dart';

class HomeScreen extends StatelessWidget {
  TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    taskController.setTask();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(AddTask(),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15))));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (taskController.loading.value) {
        return Center(
          child: Text(
            'Loading',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        );
      } else {
        return Container(
          child: Container(
            child: Column(
              children: [
                 Container(
                  padding: EdgeInsets.only(top: 15,bottom: 20,left: 8,right: 8),
                  child: TextField(
                    onChanged: (var value){
                      print("__________!!!!!!!!!!___________"+value);
                      taskController.searchText.value=value;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        labelText: "search",
                        hintText: "Search..."
                    ),
                  ),
                ),
                Expanded(
                  child: taskController.searchedTasks.length == 0?
                  Center(
                          child: Text("There Is No Item"),
                        )
                      : ListView.builder(
                          itemCount: taskController.searchedTasks.length,
                          itemBuilder: (context, index) {
                            Task task = taskController.searchedTasks[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: Colors.grey.withOpacity(0.4),
                                    )),
                                child: Container(
                                  child: ListTile(
                                    title: Text(task.description!),
                                    subtitle:
                                        Text(task.createdAt!.split('T').first),
                                    trailing: Container(
                                      width: 100,
                                      height: 50,
                                      child: Obx(
                                        () => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            taskController.deleting.value &&
                                                    taskController
                                                            .deleteID.value ==
                                                        task.sId
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        right: 12),
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      taskController
                                                          .deleteTask(task);
                                                    },
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                  ),
                                            Checkbox(
                                                value: task.completed,
                                                activeColor: Colors.green,
                                                onChanged: (value) {
                                                  taskController
                                                      .updateTask(task);
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}

class AddTask extends StatelessWidget {
  late String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          TextField(
            onChanged: (String value) {
              description = value;
            },
            decoration: InputDecoration(
              labelText: "Description",
              labelStyle: TextStyle(
                color: mediumBlue,
              ),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: mediumBlue),
              ),
            ),
            maxLines: 3,
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 55,
            child: Container(
              width: 200,
              height: 60,
              child: ProgressButton(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                strokeWidth: 2,
                color: mediumBlue,
                child: Text(
                  "Add Task",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                onPressed: (AnimationController controller) async {
                  controller.forward();
                  await Get.find<TaskController>().addTask(description);
                  controller.reverse();
                },
              ),
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
