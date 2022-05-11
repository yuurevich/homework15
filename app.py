import sqlite3

from flask import Flask, jsonify

app = Flask(__name__)


def connect(query):
    con = sqlite3.connect("animal.db")
    cur = con.cursor()
    cur.execute(query)
    response = cur.fetchall()
    cur.close()
    result = dict()
    result['id'] = response[0][0]
    result['age_upon_outcome'] = response[0][1]
    result['animal_id'] = response[0][2]
    result['animal_type'] = response[0][3]
    result['name'] = response[0][4]
    result['breed'] = response[0][5]
    result['color1'] = response[0][6]
    result['color2'] = response[0][7]
    result['date_of_birth'] = response[0][8]
    result['outcome_subtype'] = response[0][9]
    result['outcome_type'] = response[0][10]
    result['outcome_month'] = response[0][11]
    result['outcome_year'] = response[0][12]
    return result

@app.route('/<itemid>')
def main(itemid):
    SEARCH = f"""

    SELECT animals_final.id,
       age_upon_outcome,
       animals_final.animal_id,
       (SELECT type FROM types WHERE animals_final.animal_type = types.id) AS animal_type,
       animals_final.name,
       (SELECT breed FROM breeds WHERE animals_final.breed = breeds.id ) AS breed,
       (SELECT color FROM colors WHERE color1 = colors.id) AS color1,
       (SELECT color FROM colors WHERE color2 = colors.id) AS color2,
       animals_final.date_of_birth,
       outcome.outcome_subtype,
       outcome.outcome_type,
       outcome.outcome_month,
       outcome.outcome_year

FROM animals_final
JOIN outcome
    ON animals_final.outcome_id = outcome.id
JOIN animals_colors
    ON animals_final.colors = animals_colors.animal_id

WHERE animals_final.id = {itemid};
    
    """
    result = connect(SEARCH)
    return jsonify(result)


if __name__ == '__main__':
    app.run(debug=True)


