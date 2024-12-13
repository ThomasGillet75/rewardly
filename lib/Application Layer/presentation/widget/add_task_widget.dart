import 'package:flutter/material.dart';

import 'add_button_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedPriority;
  String? _selectedProject;

  final List<String> _priorities = ['Urgent', 'Important', 'Large'];
  final List<String> _projects = ['Projet A', 'Projet B', 'Projet C'];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nom de la tâche
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          border: Border.all(
                            color: const Color(0xFFB7B7B7),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            controller: _taskController,
                            autofocus: true, // Ouvre automatiquement le clavier
                            decoration: const InputDecoration(
                              hintText: "Nom de la tâche",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Description multi-lignes
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          border: Border.all(
                            color: const Color(0xFFB7B7B7),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: 3, // Permet d'écrire sur plusieurs lignes
                            decoration: const InputDecoration(
                              hintText: "Description de la tâche",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Date, Priorité, Projet et Add
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Sélecteur de date
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _dateController.text =
                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            });
                          }
                        },
                        child: Container(
                          height: 48, // Assure une hauteur cohérente
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            border: Border.all(
                              color: const Color(0xFFB7B7B7),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0), // Alignement
                            child: Align(
                              alignment: Alignment.centerLeft, // Alignement à gauche
                              child: Text(
                                _dateController.text.isNotEmpty
                                    ? _dateController.text
                                    : "Date",
                                style: const TextStyle(
                                  fontSize: 11, // Taille de texte identique
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Menu déroulant priorité
                    Expanded(
                      child: Container(
                        height: 48, // Hauteur uniforme
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          border: Border.all(
                            color: const Color(0xFFB7B7B7),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPriority,
                            hint: const Text(
                              "Priorité",
                              style: TextStyle(fontSize: 12),
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, size: 16),
                            items: _priorities.map((priority) {
                              return DropdownMenuItem(
                                value: priority,
                                child: Text(
                                  priority,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Menu déroulant projet
                    Expanded(
                      child: Container(
                        height: 48, // Hauteur uniforme
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          border: Border.all(
                            color: const Color(0xFFB7B7B7),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedProject,
                            hint: const Text(
                              "Projet",
                              style: TextStyle(fontSize: 12),
                            ),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down, size: 16),
                            items: _projects.map((project) {
                              return DropdownMenuItem(
                                value: project,
                                child: Text(
                                  project,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedProject = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Bouton "Add"
                    const AddButtonWidget(),
                  ],
                ),
                const SizedBox(height: 16), // Marges inférieures
              ],
            ),
          ),
        ),
      ),
    );
  }
}
