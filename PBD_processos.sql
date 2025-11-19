-- Buscar veículos disponíveis na cidade do cliente
SELECT 
    v.id_veiculo,
    v.modelo,
    v.placa,
    c.nome AS categoria,
    l.nome AS loja,
    ci.nome AS cidade
FROM Veiculo v
JOIN CategoriaVeiculo c ON v.id_categoria = c.id_categoria
JOIN Loja l ON v.id_loja_atual = l.id_loja
JOIN Cidade ci ON l.id_cidade = ci.id_cidade
WHERE v.status = 'Livre'
  AND ci.id_cidade = :idCidade;


-- Encontrar o veículo disponível mais próximo da loja solicitada
SELECT 
    v.id_veiculo,
    v.modelo,
    v.placa,
    l.nome AS loja_atual,
    ci.nome AS cidade
FROM Veiculo v
JOIN Loja l ON v.id_loja_atual = l.id_loja
JOIN Cidade ci ON l.id_cidade = ci.id_cidade
WHERE v.status = 'Livre'
  AND ci.id_cidade = (
        SELECT id_cidade 
        FROM Loja 
        WHERE id_loja = :lojaRetirada
    )
ORDER BY v.id_loja_atual = :lojaRetirada DESC
LIMIT 1;


-- Listar reservas do cliente com detalhes
SELECT 
    r.id_reserva,
    r.data_reserva,
    r.periodo,
    r.status,
    lr.nome AS loja_retirada,
    ld.nome AS loja_devolucao,
    v.modelo AS veiculo,
    v.placa
FROM Reserva r
JOIN Cliente c ON r.id_cliente = c.id_cliente
LEFT JOIN Locacao lo ON lo.id_reserva = r.id_reserva
LEFT JOIN Veiculo v ON lo.id_veiculo = v.id_veiculo
JOIN Loja lr ON r.id_loja_retirada = lr.id_loja
JOIN Loja ld ON r.id_loja_retorno = ld.id_loja
WHERE c.id_cliente = :idCliente;


-- Relatório financeiro por período e cidade
SELECT 
    ci.nome AS cidade,
    COUNT(lo.id_locacao) AS total_locacoes,
    SUM(lo.valor_pago) AS receita_total,
    AVG(lo.valor_pago) AS ticket_medio
FROM Locacao lo
JOIN Veiculo v ON lo.id_veiculo = v.id_veiculo
JOIN Loja l ON v.id_loja_atual = l.id_loja
JOIN Cidade ci ON l.id_cidade = ci.id_cidade
WHERE lo.data_inicio BETWEEN :dataInicio AND :dataFim
GROUP BY ci.nome;


-- Listar veículos em manutenção por cidade
SELECT 
    v.modelo,
    v.placa,
    l.nome AS loja,
    ci.nome AS cidade
FROM Veiculo v
JOIN Loja l ON v.id_loja_atual = l.id_loja
JOIN Cidade ci ON l.id_cidade = ci.id_cidade
WHERE v.status = 'Manutencao';


-- Locações com motorista incluso
SELECT 
    lo.id_locacao,
    c.nome AS cliente,
    v.modelo AS veiculo,
    m.nome AS motorista
FROM Locacao lo
JOIN Reserva r ON lo.id_reserva = r.id_reserva
JOIN Cliente c ON r.id_cliente = c.id_cliente
JOIN Veiculo v ON lo.id_veiculo = v.id_veiculo
JOIN LocacaoMotorista lm ON lo.id_locacao = lm.id_locacao
JOIN Motorista m ON lm.id_motorista = m.id_motorista;


-- Ranking dos modelos mais alugados
SELECT 
    v.modelo,
    COUNT(lo.id_locacao) AS vezes_alugado
FROM Locacao lo
JOIN Veiculo v ON lo.id_veiculo = v.id_veiculo
GROUP BY v.modelo
ORDER BY vezes_alugado DESC;
