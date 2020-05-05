create trigger deletarCliente_tg on Cliente
instead of delete
as
begin
declare @idCliente int = null
select @idCliente = idCliente from deleted
delete from Favorito where idCliente = @idCliente
delete from Endereco where idCliente = @idCliente
delete from Cartao where idCliente = @idCliente
delete from Avaliacao where idCliente = @idCliente
delete from Resposta where idCliente = @idCliente
delete from HistoricoDeAcessoCliente where idCliente = @idCliente
delete from Cliente where idCliente = @idCliente
end


