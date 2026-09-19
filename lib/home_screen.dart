import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/contato_model.dart';
import 'package:flutter_application_2/services/contato_banco.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  List<ContatoModel> _listarContatos = [];

  @override
  void initState() {
    super.initState();
    _carregarLista();
  }

  void _carregarLista() async {
    final contatos = await ContatoBanco().listarContatos();
    setState(() {
      _listarContatos = contatos;
    });
  }

  void abrirFormulario(ContatoModel contato) {
    _nomeController.text = contato.nome;
    _emailController.text = contato.email;
    _telefoneController.text = contato.telefone;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contato.id == null ? "Novo Cadastro" : "Editar Contato"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(label: Text("Nome")),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(label: Text("Email")),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _telefoneController,
                decoration: const InputDecoration(label: Text("Telefone")),
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _limparFormulario();
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => _salvarDados(contato),
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void _limparFormulario() {
    _nomeController.clear();
    _emailController.clear();
    _telefoneController.clear();
  }

  void _salvarDados(ContatoModel contato) async {
    final novoContato = ContatoModel(
      nome: _nomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      id: contato.id,
    );

    bool ehNovoCadastro = contato.id == null;
    bool salvou = false;

    if (ehNovoCadastro) {
      salvou = await ContatoBanco().inserirContato(novoContato);
    } else {
      salvou = await ContatoBanco().atualizarContato(novoContato);
    }

    if (salvou && mounted) {
      _carregarLista();
      _limparFormulario();
      Navigator.of(context).pop();
    }
  }

  //modal confirmação

  void _abrirModalExclusao(ContatoModel contato) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Excluir contato"),
          content: Text("Tem certeza que deseja excluir ${contato.nome}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop,
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => _deletarContato(contato.id!),
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  void _deletarContato(int id) async {
    bool deletou = await ContatoBanco().deletarContato(id);
    if (deletou && mounted) {
      _carregarLista(); // Atualiza a tela após excluir
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Contato apagado")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de contatos"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: _listarContatos.length,
        itemBuilder: (context, index) {
          final item = _listarContatos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(item.nome),
              subtitle: Text('${item.email} - ${item.telefone}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => abrirFormulario(item),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _deletarContato(item.id!),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _limparFormulario();
          abrirFormulario(ContatoModel(nome: "", email: "", telefone: ""));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
