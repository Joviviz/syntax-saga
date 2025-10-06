from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
import MySQLdb.cursors

app = Flask(__name__)

# Configuração do banco MySQL
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '252411'
app.config['MYSQL_DB'] = 'jogo_db'

mysql = MySQL(app)

# =====================
# CRUD para Jogador
# =====================
@app.route('/jogadores', methods=['POST'])
def criar_jogador():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        INSERT INTO Jogador (nome, email, senha_hash)
        VALUES (%s, %s, %s)
    """, (data['nome'], data['email'], data['senha_hash']))
    mysql.connection.commit()
    return jsonify({"message": "Jogador criado com sucesso"}), 201

@app.route('/jogadores', methods=['GET'])
def listar_jogadores():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM Jogador")
    jogadores = cursor.fetchall()
    return jsonify(jogadores)

@app.route('/jogadores/<int:id>', methods=['PUT'])
def atualizar_jogador(id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE Jogador SET nome=%s, email=%s, senha_hash=%s WHERE id_jogador=%s
    """, (data['nome'], data['email'], data['senha_hash'], id))
    mysql.connection.commit()
    return jsonify({"message": "Jogador atualizado com sucesso"})

@app.route('/jogadores/<int:id>', methods=['DELETE'])
def deletar_jogador(id):
    cursor = mysql.connection.cursor()
    cursor.execute("DELETE FROM Jogador WHERE id_jogador=%s", (id,))
    mysql.connection.commit()
    return jsonify({"message": "Jogador deletado com sucesso"})

# =====================
# CRUD para Fase
# =====================
@app.route('/fases', methods=['POST'])
def criar_fase():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        INSERT INTO Fase (nome_fase, ordem, dificuldade)
        VALUES (%s, %s, %s)
    """, (data['nome_fase'], data['ordem'], data['dificuldade']))
    mysql.connection.commit()
    return jsonify({"message": "Fase criada com sucesso"}), 201

@app.route('/fases', methods=['GET'])
def listar_fases():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM Fase")
    fases = cursor.fetchall()
    return jsonify(fases)

@app.route('/fases/<int:id>', methods=['PUT'])
def atualizar_fase(id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE Fase SET nome_fase=%s, ordem=%s, dificuldade=%s WHERE id_fase=%s
    """, (data['nome_fase'], data['ordem'], data['dificuldade'], id))
    mysql.connection.commit()
    return jsonify({"message": "Fase atualizada com sucesso"})

@app.route('/fases/<int:id>', methods=['DELETE'])
def deletar_fase(id):
    cursor = mysql.connection.cursor()
    cursor.execute("DELETE FROM Fase WHERE id_fase=%s", (id,))
    mysql.connection.commit()
    return jsonify({"message": "Fase deletada com sucesso"})

# =====================
# CRUD para Progresso
# =====================
@app.route('/progresso', methods=['POST'])
def criar_progresso():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        INSERT INTO Progresso (id_jogador, id_fase, status)
        VALUES (%s, %s, %s)
    """, (data['id_jogador'], data['id_fase'], data['status']))
    mysql.connection.commit()
    return jsonify({"message": "Progresso criado com sucesso"}), 201

@app.route('/progresso', methods=['GET'])
def listar_progresso():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM Progresso")
    progresso = cursor.fetchall()
    return jsonify(progresso)

@app.route('/progresso/<int:id>', methods=['PUT'])
def atualizar_progresso(id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE Progresso SET id_jogador=%s, id_fase=%s, status=%s 
        WHERE id_progresso=%s
    """, (data['id_jogador'], data['id_fase'], data['status'], id))
    mysql.connection.commit()
    return jsonify({"message": "Progresso atualizado com sucesso"})

@app.route('/progresso/<int:id>', methods=['DELETE'])
def deletar_progresso(id):
    cursor = mysql.connection.cursor()
    cursor.execute("DELETE FROM Progresso WHERE id_progresso=%s", (id,))
    mysql.connection.commit()
    return jsonify({"message": "Progresso deletado com sucesso"})

# =====================
# CRUD para Pontuação
# =====================
@app.route('/pontuacoes', methods=['POST'])
def criar_pontuacao():
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        INSERT INTO Pontuacao (id_jogador, id_fase, tempo_segundos, pontos)
        VALUES (%s, %s, %s, %s)
    """, (data['id_jogador'], data['id_fase'], data['tempo_segundos'], data['pontos']))
    mysql.connection.commit()
    return jsonify({"message": "Pontuação criada com sucesso"}), 201

@app.route('/pontuacoes', methods=['GET'])
def listar_pontuacoes():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM Pontuacao")
    pontuacoes = cursor.fetchall()
    return jsonify(pontuacoes)

@app.route('/pontuacoes/<int:id>', methods=['PUT'])
def atualizar_pontuacao(id):
    data = request.json
    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE Pontuacao SET id_jogador=%s, id_fase=%s, tempo_segundos=%s, pontos=%s
        WHERE id_pontuacao=%s
    """, (data['id_jogador'], data['id_fase'], data['tempo_segundos'], data['pontos'], id))
    mysql.connection.commit()
    return jsonify({"message": "Pontuação atualizada com sucesso"})

@app.route('/pontuacoes/<int:id>', methods=['DELETE'])
def deletar_pontuacao(id):
    cursor = mysql.connection.cursor()
    cursor.execute("DELETE FROM Pontuacao WHERE id_pontuacao=%s", (id,))
    mysql.connection.commit()
    return jsonify({"message": "Pontuação deletada com sucesso"})


# =====================
# Iniciar servidor
# =====================
if __name__ == '__main__':
    app.run(debug=True)
