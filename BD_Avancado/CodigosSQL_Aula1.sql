-- comentário de linha 
/* comentário de bloco */
CREATE TABLE laboratorio (
cd_laboratorio INT AUTO_INCREMENT PRIMARY KEY,
nm_laboratorio VARCHAR(50) NOT NULL,
ds_website	   VARCHAR(50)
);

CREATE TABLE medicamento (
cd_medicamento INT AUTO_INCREMENT PRIMARY KEY,
nm_medicamento VARCHAR(50),
ds_medicamento VARCHAR(50),
vl_custo 	   DECIMAL(8,2) DEFAULT 0.00,
vl_venda 	   DECIMAL(8,2),
cd_anvisa 	   VARCHAR(8),
cd_laboratorio INT NOT NULL REFERENCES laboratorio(cd_laboratorio)
);

CREATE TABLE lote (
cd_medicamento  INT,
nr_lote 		INT,
ds_lote			VARCHAR(50),
dt_fabricacao 	DATE,
dt_venciemnto   DATE,
qt_estoque		INT,
PRIMARY KEY (cd_medicamento,nr_lote),
FOREIGN KEY (cd_medicamento) REFERENCES medicamento(cd_medicamento)
);

CREATE TABLE medicamento_similar (
cd_medicamento         INT,
cd_medicamento_similar INT,
PRIMARY KEY (cd_medicamento, cd_medicamento_similar)
);

ALTER table medicamento_similar 
	ADD FOREIGN KEY (cd_medicamento) REFERENCES medicamento(cd_medicamento);
	
ALTER table medicamento_similar 
	ADD FOREIGN KEY (cd_medicamento_similar) REFERENCES medicamento(cd_medicamento);	
	
	
-- LABORATÓRIOS (20)
INSERT INTO laboratorio (nm_laboratorio, ds_website) VALUES
('MedLab', '[www.medlab.com]'),
('Farmatec', '[www.farmatec.com]'),
('BioSaude', '[www.biosaude.com]'),
('VidaPharma', '[www.vidapharma.com]'),
('UniMedic', '[www.unimedic.com]'),
('HealthPlus', '[www.healthplus.com]'),
('NovaFarma', '[www.novafarma.com]'),
('PharmaSul', '[www.pharmasul.com]'),
('CuraMais', '[www.curamais.com]'),
('BemEstar', '[www.bemestar.com]'),
('MedSul', '[www.medsul.com]'),
('GenFarma', '[www.genfarma.com]'),
('Vitalis', '[www.vitalis.com]'),
('BioLife', '[www.biolife.com]'),
('FarmaVida', '[www.farmavida.com]'),
('ClinPharma', '[www.clinpharma.com]'),
('SaudeTotal', '[www.saudetotal.com]'),
('PharmaBrasil', '[www.pharmabrasil.com]'),
('LifeCare', '[www.lifecare.com]'),
('MedPrime', '[www.medprime.com]');
 
-- MEDICAMENTOS (20)
INSERT INTO medicamento (nm_medicamento, ds_medicamento, vl_custo, vl_venda, cd_anvisa, cd_laboratorio) VALUES
('Paracetamol', 'Analgésico', 2.50, 5.00, 'A0000001', 1),
('Dipirona', 'Analgésico', 2.00, 4.50, 'A0000002', 2),
('Ibuprofeno', 'Anti-inflamatório', 4.00, 9.50, 'A0000003', 3),
('Amoxicilina', 'Antibiótico', 8.00, 18.00, 'A0000004', 4),
('Azitromicina', 'Antibiótico', 12.00, 28.00, 'A0000005', 5),
('Omeprazol', 'Antiácido', 3.50, 8.00, 'A0000006', 6),
('Losartana', 'Anti-hipertensivo', 5.00, 11.00, 'A0000007', 7),
('Atenolol', 'Anti-hipertensivo', 4.50, 10.00, 'A0000008', 8),
('Metformina', 'Antidiabético', 6.00, 14.00, 'A0000009', 9),
('Insulina', 'Hormônio', 30.00, 65.00, 'A0000010', 10),
('Sinvastatina', 'Redutor colesterol', 7.00, 15.00, 'A0000011', 11),
('Atorvastatina', 'Redutor colesterol', 9.00, 20.00, 'A0000012', 12),
('Ranitidina', 'Antiácido', 3.00, 7.00, 'A0000013', 13),
('Clonazepam', 'Ansiolítico', 10.00, 22.00, 'A0000014', 14),
('Fluoxetina', 'Antidepressivo', 11.00, 24.00, 'A0000015', 15),
('Sertralina', 'Antidepressivo', 12.00, 26.00, 'A0000016', 16),
('Vitamina C', 'Suplemento', 2.00, 6.00, 'A0000017', 17),
('Vitamina D', 'Suplemento', 2.50, 7.00, 'A0000018', 18),
('Prednisona', 'Corticóide', 6.50, 14.50, 'A0000019', 19),
('Hidrocortisona', 'Corticóide', 7.00, 16.00, 'A0000020', 20);
 
-- LOTES (mínimo 20)
INSERT INTO lote (cd_medicamento, nr_lote, ds_lote, dt_fabricacao, dt_venciemnto, qt_estoque) VALUES
(1,1, 'Lote A1', '2024-01-01', '2026-01-01', 100),
(1,2, 'Lote A2', '2023-01-01', '2025-01-01', 50),
(2,2, 'Lote B1', '2024-02-01', '2026-02-01', 80),
(3,3, 'Lote C1', '2024-03-01', '2026-03-01', 60),
(4,4, 'Lote D1', '2023-04-01', '2024-04-01', 0),
(5,5, 'Lote E1', '2024-05-01', '2026-05-01', 40),
(6,6, 'Lote F1', '2024-06-01', '2026-06-01', 70),
(7,7, 'Lote G1', '2024-07-01', '2026-07-01', 90),
(8,8, 'Lote H1', '2023-08-01', '2024-08-01', 10),
(9,9, 'Lote I1', '2024-09-01', '2026-09-01', 55),
(10,10,'Lote J1', '2024-01-10', '2026-01-10', 25),
(11,11,'Lote K1', '2024-02-10', '2026-02-10', 35),
(12,12,'Lote L1', '2024-03-10', '2026-03-10', 45),
(13,13,'Lote M1', '2023-04-10', '2024-04-10', 0),
(14,14,'Lote N1', '2024-05-10', '2026-05-10', 65),
(15,15,'Lote O1', '2024-06-10', '2026-06-10', 75),
(16,16,'Lote P1', '2024-07-10', '2026-07-10', 85),
(17,17,'Lote Q1', '2024-08-10', '2026-08-10', 95),
(18,18,'Lote R1', '2024-09-10', '2026-09-10', 20),
(19,19,'Lote S1', '2024-10-10', '2026-10-10', 30);
 
-- MEDICAMENTOS SIMILARES
INSERT INTO medicamento_similar VALUES
(1, 2),
(3, 4),
(6, 13),
(11, 12),
(15, 16);	


-- junção simples
SELECT m.nm_medicamento, l.nm_laboratorio
FROM medicamento m, laboratorio l
WHERE m.cd_laboratorio = l.cd_laboratorio;
-- ou
SELECT m.nm_medicamento, l.nm_laboratorio
FROM medicamento m RIGHT JOIN laboratorio l ON (m.cd_laboratorio = l.cd_laboratorio)
WHERE m.nm_medicamento IS NULL;

-- alterando para o medicamento 10 não ter laboratório 
ALTER TABLE medicamento 
MODIFY COLUMN cd_laboratorio INT NULL;

UPDATE medicamento SET cd_laboratorio = NULL WHERE cd_medicamento = 10;

-- listando quantos medicamento há em cada laboratório 
SELECT l.nm_laboratorio, COUNT(m.cd_laboratorio) AS qtde
FROM laboratorio l JOIN medicamento m ON (l.cd_laboratorio = m.cd_laboratorio)
GROUP BY l.nm_laboratorio;

-- medicamento similar
SELECT * FROM medicamento_similar;

SELECT m.nm_medicamento, s.nm_medicamento
FROM medicamento m JOIN medicamento_similar ms ON (m.cd_medicamento = ms.cd_medicamento)
				   JOIN medicamento s ON (s.cd_medicamento = ms.cd_medicamento_similar);

