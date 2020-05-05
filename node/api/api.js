
const express = require('express');
const fs = require('fs');
const app = express();         
const bodyParser = require('body-parser');
const porta = 3000; //porta padrão
const sql = require('mssql');
const conexaoStr = "Server=regulus.cotuca.unicamp.br;Database=Indomuss;User Id=BD18189;Password=maguisa;";

//conexao com BD
sql.connect(conexaoStr)
   .then(conexao => global.conexao = conexao)
   .catch(erro => console.log(erro));

// configurando o body parser para pegar POSTS mais tarde   
app.use(bodyParser.urlencoded({ limit: '500gb', extended: true}));
app.use(bodyParser.json({ limit: '500gb', extended: true}));
//acrescentando informacoes de cabecalho para suportar o CORS
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  res.header("Access-Control-Allow-Methods", "GET, POST, HEAD, OPTIONS, PATCH, DELETE");
  next();
});
//definindo as rotas
const rota = express.Router();
rota.get('/', (requisicao, resposta) => resposta.json({ mensagem: 'Funcionando!'}));
app.use('/', rota);

//inicia servidor
app.listen(porta);
console.log('API Funcionando!');

function execSQL(sql, resposta) {
	global.conexao.request()
				  .query(sql)
				  .then(resultado => resposta.json(resultado.recordset))
				  .catch(erro => resposta.json(erro));
}

rota.post('/cadastrarCliente', (requisicao, resposta) =>{
  const nome = requisicao.body.nome;
  const senha = requisicao.body.senha;
  const rg = requisicao.body.rg;
  const cpf = requisicao.body.cpf;
  const email = requisicao.body.email;
  const numeroCelular = requisicao.body.numeroCelular;
  const dataNascimento = requisicao.body.dataNascimento;
  const genero = requisicao.body.genero;
  const querGenero = requisicao.body.querGenero;
  const descricao = requisicao.body.descricao;
  const foto = requisicao.body.foto;
  execSQL(`cadastroCliente_sp '${rg}', '${cpf}', '${nome}', '${email}', '${numeroCelular}', '${dataNascimento}', '${genero}', ${querGenero}, '${descricao}', '${foto}',${senha}`, resposta);
})

rota.post('/cadastrarProfissional', (requisicao, resposta) =>{
  const nome = requisicao.body.nome;
  const senha = requisicao.body.senha;
  const rg = requisicao.body.rg;
  const cpf = requisicao.body.cpf;
  const email = requisicao.body.email;
  const numeroCelular = requisicao.body.numeroCelular;
  const dataNascimento = requisicao.body.dataNascimento;
  const genero = requisicao.body.genero;
  const querGenero = requisicao.body.querGenero;
  const descricao = requisicao.body.descricao;
  const foto = requisicao.body.foto;
  const cnpj = requisicao.body.cnpj;
  const cep = requisicao.body.cep;
  const nomeServico = requisicao.body.nomeServico;
  execSQL(`cadastroProfissional_sp '${rg}', '${cpf}', '${cnpj}','${nome}', '${email}', '${cep}','${numeroCelular}', '${dataNascimento}', '${genero}', ${querGenero}, '${descricao}', '${foto}',${senha}, '${nomeServico}'`, resposta);
})

rota.post('/loginCliente', (requisicao, resposta) =>{
  const email = requisicao.body.email;
  const senha = requisicao.body.senha;
  execSQL(`acessoCliente_sp '${email}', '${senha}'`, resposta);
})

rota.post('/loginProfissional', (requisicao, resposta) =>{
  const email = requisicao.body.email;
  const senha = requisicao.body.senha;
  execSQL(`acessoProfissional_sp '${email}', '${senha}'`, resposta);
})

rota.delete("/excluiCliente", (requisicao, resposta)=>{
  const email = requisicao.body.email;
  const senha = requisicao.body.senha;
	execSQL(`excluirCliente '${email}', '${senha}'`, resposta);
})

rota.delete("/excluiProfissional", (requisicao, resposta)=>{
  const email = requisicao.body.email;
  const senha = requisicao.body.senha;
	execSQL(`excluirProfissional '${email}', '${senha}'`, resposta);
})

rota.patch("/altera/:campo/:cliente?", (requisicao, resposta) =>{
  const email = requisicao.body.email;
  const novoValor = requisicao.body.novoValor;
  const campo = requisicao.params.campo;
  if(campo)
  {
      if(campo == "email" || campo == "senha")
      {
        if(requisicao.params.cliente){
          const sql = `alteraSenhaEmailCliente '${email}', ${campo == "email"? "'"+ novoValor +"', null":"null , '"+ novoValor +"'"}`;
          execSQL(`alteraSenhaEmailCliente_sp '${email}', ${campo == "email"? "'"+ novoValor +"', null":"null , '"+ novoValor +"'"}`, resposta);
        }
        else
          execSQL(`alteraSenhaEmailProfissional_sp '${email}', ${campo == "email"? "'"+ novoValor +"', null":"null, '"+ novoValor +"'"}`, resposta);
      }
      else if(campo == "servico")
      {
          execSQL(`update Profissional set idServico = (select idServico from Servico where nome = '${novoServico}') where email='${email}'`, resposta);
      }
      else
      {
        if(requisicao.params.cliente)
          execSQL(`update Cliente set ${campo} = ${campo == "querGenero"? novoValor: "'"+ novoValor + "'"} where email='${email}'`, resposta);
        else
          execSQL(`update Profissional set ${campo} =  ${campo == "querGenero"? novoValor: "'"+ novoValor + "'"} where email='${email}'`, resposta);
      }
    }
})