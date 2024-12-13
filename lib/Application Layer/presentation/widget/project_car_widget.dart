import 'package:flutter/material.dart';

class ProjectCarWidget extends StatefulWidget {
  const ProjectCarWidget({super.key, required this.projectName});

  final String projectName;

  @override
  State<ProjectCarWidget> createState() => _ProjectCardWdigetState();
}

class _ProjectCardWdigetState extends State<ProjectCarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => print("Mes taches"),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.projectName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
