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
  TextEditingController controllerTarefa = TextEditingController();
  Map<String, dynamic> tarefaExcluida = {};

  Future<File> getDiretorio() async {
    //Recuperar diretorio.
    final diretorio = await getApplicationDocumentsDirectory();
    print(diretorio.path);
    return File('${diretorio.path}/dados.json');
  }

  salvarArquivo() async {

    var arquivo = await getDiretorio();  
    var dados = jsonEncode(listaTarefas);
    arquivo.writeAsString(dados);    

  }

  salvarTarefa(){

    var textodigitado = controllerTarefa.text;

    //Criar dados.
    Map<String, dynamic> tarefa = {};
    tarefa['titulo'] = textodigitado;
    tarefa['realizada'] = false;

    setState(() {
    listaTarefas.add(tarefa);      
    });

    salvarArquivo();
    controllerTarefa.text = '';
  }

  lerArquivo() async {

    try{

    var arquivo = await getDiretorio();
    return arquivo.readAsString();

    }catch(e){
      return null;
    }    

  }

  @override
  void initState() {
    super.initState();
    lerArquivo().then((dados){
      setState(() {
        listaTarefas = jsonDecode(dados);
      });
    });
  }

  Widget criarItemLista(context, index){

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (direction){

        //Recuperar item decartado.
        tarefaExcluida = listaTarefas[index];
        listaTarefas.removeAt(index);
        salvarArquivo();

        final snackbar = SnackBar(
          content: Text('Tarefa excluída'),
          action: SnackBarAction(
            label: 'Desfazer', 
            onPressed: (){
              setState(() {
              listaTarefas.insert(index, tarefaExcluida);                
              });
              salvarArquivo();
            }),);
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      } ,
      background: Container(
        padding: EdgeInsets.all(16),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(Icons.delete, 
            color: Colors.white,)
          ],
        ),
      ),
      child: CheckboxListTile(
              title: Text(listaTarefas[index]['titulo']),
              value: listaTarefas[index]['realizada'], 
              onChanged: (valorAlterado){
                setState(() {
                listaTarefas[index]['realizada']=valorAlterado;                
                });
    
                salvarArquivo();
    
              }),
    );

  }

  @override
  Widget build(BuildContext context) {

    // salvarArquivo();
    // print(listaTarefas.toString());

    return Scaffold(
      appBar: AppBar(title: Text('ListaTarefas de tarefas'),
      backgroundColor: Colors.purple),
      body: ListView.builder(
        itemCount: listaTarefas.length,
        itemBuilder: criarItemLista
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
                  controller: controllerTarefa,
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
                      salvarTarefa();
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
