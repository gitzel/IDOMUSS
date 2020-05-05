create trigger deletarProfissional_tg on Profissional
instead of delete
as
begin
declare @idProfissional int = null
select @idProfissional = idProfissional from deleted
delete from Favorito where idProfissional = @idProfissional
delete from ProfissionalVIP where idProfissional = @idProfissional
delete from Avaliacao where idProfissional = @idProfissional
delete from Resposta where idProfissional = @idProfissional
delete from HistoricoDeAcessoProfissional where idProfissional = @idProfissional
delete from Profissional where idProfissional = @idProfissional
end
