cadastroCliente_sp '62431352X', '57611189154', 'teste1', 'teste2@gmail.com', '1912345678923', '15/06/2001', 'mulher',1, 'sou linda', 'aaaaa','cosdkc'

delete from Cliente
select * from Cliente

cadastroProfissional_sp '62431352X', '57611189154', '01234567891234','teste1', 'teste2@gmail.com', '13060033', '1912345678923', '15/06/2001', 'mulher',1, 'sou linda', 'aaaaa','cosdkc', 'babá'

delete from Profissional
select * from Profissional

insert into Servico values('babá', 'aa', 'asa')

alter table Profissional alter column senha varbinary(max) not null