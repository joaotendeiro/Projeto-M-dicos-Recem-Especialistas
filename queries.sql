-- Especialidades com mais médicos formados
SELECT ESPECIALIDADES.nome, SUM(FORMACAO.quantidade) AS quantidade_especialidade
FROM FORMACAO
INNER JOIN ESPECIALIDADES ON FORMACAO.id_especialidade = ESPECIALIDADES.id
GROUP BY ESPECIALIDADES.nome
ORDER BY quantidade_especialidade DESC

-- Evolução do número de médicos formados por especialidade ao longo dos anos
SELECT FORMACAO.ano, ESPECIALIDADES.nome, SUM(FORMACAO.quantidade) as total_medicos
FROM FORMACAO
INNER JOIN ESPECIALIDADES ON FORMACAO.id_especialidade = ESPECIALIDADES.id
GROUP BY FORMACAO.ano, FORMACAO.id_especialidade
ORDER BY FORMACAO.ano ASC, total_medicos DESC;

-- Top especialidades por ano
WITH RankingEspecialidades AS (
    SELECT 
        FORMACAO.ano,
        ESPECIALIDADES.nome,
        MAX(FORMACAO.quantidade) as total_medicos,
        ROW_NUMBER() OVER (
            PARTITION BY FORMACAO.ano 
            ORDER BY MAX(FORMACAO.quantidade) DESC
        ) AS posicao
    FROM FORMACAO
    INNER JOIN ESPECIALIDADES ON FORMACAO.id_especialidade = ESPECIALIDADES.id
    WHERE FORMACAO.ano IN (2020, 2021, 2022, 2023, 2024, 2025)
    GROUP BY FORMACAO.ano, FORMACAO.id_especialidade, ESPECIALIDADES.nome
)
SELECT 
    ano, 
    nome, 
    total_medicos
FROM 
    RankingEspecialidades
WHERE 
    posicao = 1
ORDER BY 
    ano ASC;

-- Total de médicos formados por instituição
SELECT INSTITUICAO.nome, SUM(FORMACAO.quantidade) as Total_medicos_formados
FROM FORMACAO
INNER JOIN INSTITUICAO ON FORMACAO.id_instituicao = INSTITUICAO.id
GROUP BY INSTITUICAO.nome

-- Crescimento anual do número de médicos formados por instituição
with cte as (
	SELECT INSTITUICAO.nome, FORMACAO.ano, SUM(FORMACAO.quantidade) as Total_medicos_formados
	FROM FORMACAO
	INNER JOIN INSTITUICAO ON FORMACAO.id_instituicao = INSTITUICAO.id
	GROUP BY INSTITUICAO.nome, FORMACAO.ano
)
Select nome, ano, Total_medicos_formados
FROM cte