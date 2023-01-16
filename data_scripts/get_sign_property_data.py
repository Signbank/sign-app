import sqlite3
from sqlite3 import Error
import json


def get_all_glosses(conn):

    cur = conn.cursor()

    # cur.execute("SELECT G.id, G.locprim, G.movDir, G.domhndsh \
    #             FROM dictionary_gloss G \
    #             INNER JOIN dictionary_lemmaidgloss L ON G.lemma_id = L.id \
    #             WHERE L.dataset_id = 5 AND G.inWeb = 1 \
    #             AND G.locprim IS NOT NULL AND G.locprim IS NOT 0 \
    #             AND G.movDir IS NOT NULL AND G.movDir IS NOT 0 \
    #             AND G.domhndsh IS NOT NULL AND G.domhndsh IS NOT 0")

    cur.execute("SELECT G.id, F1.dutch_name, F2.dutch_name, F3.dutch_name \
                FROM dictionary_gloss G \
                INNER JOIN dictionary_lemmaidgloss L ON G.lemma_id = L.id \
                LEFT JOIN dictionary_fieldchoice F1 \
                ON G.locprim = F1.machine_value \
                LEFT JOIN dictionary_fieldchoice F2 \
                ON G.movDir = F2.machine_value \
                LEFT JOIN dictionary_fieldchoice F3 \
                ON G.domhndsh = F3.machine_value \
                WHERE L.dataset_id = 5 AND G.inWeb = 1  \
                AND G.locprim IS NOT NULL AND G.locprim IS NOT 0 AND F1.field = 'Location' \
                AND G.movDir IS NOT NULL AND G.movDir IS NOT 0 AND F2.field = 'MovementDir' \
                AND G.domhndsh IS NOT NULL AND G.domhndsh IS NOT 0 AND F3.field = 'Handshape'")

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


def set_spoken_value(item, complete_list, spoken_value):
    try:
        index = complete_list.index(item)

        current_value = complete_list[index][1]
        if current_value < spoken_value:
            complete_list[index][1] = spoken_value
    except ValueError:
        complete_list.append(item)


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
    complete_list = []

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

                    item = [id, spoken_amount, gloss[1], gloss[2], gloss[3]]
                    set_spoken_value(item, complete_list, spoken_amount)

                except KeyError:
                    count += 1

    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()

            output_file = open("sign_property_data.txt", "w")
            output_file.write(json.dumps(complete_list))
            output_file.close()
