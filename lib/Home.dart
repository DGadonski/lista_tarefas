// ignore_for_file: prefer_const_constructors, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List listaTarefas= [];

  salvarArquivo() async {
    //Recuperar diretorio.
    final diretorio = await getApplicationDocumentsDirectory();
    var arquivo = File('${diretorio.path}/dados.json');

    //Criar dados.
    Map<String, dynamic> tarefa = Map();
    tarefa['titulo'] = 'Ir ao mercado';
    tarefa['realizada'] = false;
    listaTarefas.add(tarefa);

    String dados = jsonEncode(listaTarefas);

    arquivo.writeAsString(dados);

  }

  @override
  Widget build(BuildContext context) {

    salvarArquivo();

    return Scaffold(
      appBar: AppBar(title: Text('ListaTarefas de tarefas'),
      backgroundColor: Colors.purple),
      body: ListView.builder(
        itemCount: listaTarefas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listaTarefas[index]),
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
