// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> lista = ['Ir ao mercado', 'Estudar', 'Teste'];
  bool? valor1 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de tarefas'),
      backgroundColor: Colors.purple),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lista[index]),
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        elevation: 6,
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text('Adicionar Tarefa'),
                content: TextField(
                  decoration: InputDecoration(
                    labelText: 'Digite sua tarefa'
                  ),
                  onChanged: (text){

                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: ()=>Navigator.pop(context), 
                    child: Text('Cancelar')),
                  ElevatedButton(
                    onPressed: (){
                      //salvar

                      Navigator.pop(context);
                    }, 
                    child: Text('Salvar')),
                ],
              );
            });
        }),
      //bottomNavigationBar: ,
    );
  }
}
