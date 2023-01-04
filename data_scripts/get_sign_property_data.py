import sqlite3
from sqlite3 import Error
import json


def get_all_glosses(conn):

    cur = conn.cursor()

    cur.execute("SELECT G.id, G.locprim, G.movDir, G.domhndsh \
                FROM dictionary_gloss \
                G INNER JOIN dictionary_lemmaidgloss L ON G.lemma_id = L.id \
                WHERE L.dataset_id = 5 AND G.inWeb = 1 \
                AND G.locprim IS NOT NULL AND G.locprim IS NOT 0 \
                AND G.movDir IS NOT NULL AND G.movDir IS NOT 0 \
                AND G.domhndsh IS NOT NULL AND G.domhndsh IS NOT 0")

    dict = {}
    for row in cur.fetchall():
        dict[row[0]] = row

    return dict


def get_all_translations(conn):
    cur = conn.cursor()

    cur.execute("SELECT T.gloss_id, K.text \
            FROM dictionary_keyword K \
            INNER JOIN dictionary_translation T ON K.id = T.translation_id \
            INNER JOIN dictionary_gloss G ON T.gloss_id = G.id \
            INNER JOIN dictionary_lemmaidgloss L ON G.lemma_id = L.id \
            WHERE L.dataset_id = 5 AND G.inWeb = 1")

    dict = {}
    for row in cur.fetchall():
        dict[row[1].lower()] = row[0]

    return dict


def set_spoken_value(key, item, dictionary, spoken_value):
    if key not in dictionary:
        dictionary[key] = item
        return

    current_value = dictionary[key][0]
    if current_value < spoken_value:
        dictionary[key][0] = spoken_value


if __name__ == '__main__':

    glosses = []
    translations = []

    db_file = r"./Data/signbank.db"
    conn = None

    f = open(r"./Data/totrank.txt", "r")
    lines = f.readlines()

    # dictionaries that are used to save the frequency data
    locations = {}
    movement = {}
    handshapes = {}
    complete_dic = {}

    try:
        conn = sqlite3.connect(db_file)

        glosses = get_all_glosses(conn)
        translations = get_all_translations(conn)

        # Remove first line without data
        lines.pop(0)

        count = 0

        for line in lines:
            line = line.split()
            if len(line) >= 3:
                try:
                    key = line[2].lower()
                    spoken_amount = int(line[1])
                    id = translations[key]
                    gloss = glosses[id]

                    item = [spoken_amount, gloss[1], gloss[2], gloss[3]]
                    set_spoken_value(id, item, complete_dic, spoken_amount)

                except KeyError:
                    count += 1

    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()

            output_file = open("sign_property_data.txt", "w")
            output_file.write(json.dumps(complete_dic))
            output_file.close()
