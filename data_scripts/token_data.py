import sqlite3
from sqlite3 import Error
import numpy as np

def get_all_glosses(conn):
    cur = conn.cursor()

    cur.execute("SELECT G.id, G.locprim, G.movDir, G.domhndsh FROM dictionary_gloss G INNER JOIN dictionary_lemmaidgloss L ON G.lemma_id = L.id WHERE L.dataset_id = 5 AND G.inWeb = 1 AND G.locprim IS NOT NULL AND G.locprim IS NOT 0 AND G.movDir IS NOT NULL AND G.movDir IS NOT 0 AND G.domhndsh IS NOT NULL AND G.domhndsh IS NOT 0")

    dict = {}
    for row in cur.fetchall():
        dict[row[0]] = row

    return dict

def get_all_translations(conn):
    cur = conn.cursor()

    cur.execute("SELECT T.gloss_id, K.text FROM dictionary_keyword K INNER JOIN dictionary_translation T ON K.id = T.translation_id INNER JOIN dictionary_gloss G ON T.gloss_id = G.id INNER JOIN dictionary_lemmaidgloss L ON G.lemma_id = L.id WHERE L.dataset_id = 5 AND G.inWeb = 1")

    dict = {}
    for row in cur.fetchall():
        dict[row[1].lower()] = row[0] 

    return dict

def check_number_of_words_not_in_dataset():
        count = 0

        keys = translations.keys()

        words = [x.split()[2].lower() for x in lines if len(x)>=3]

        for key in keys:
            if key.lower() not in words:
                count+=1

        print(count)

def print_ten_most_used(dictionary):
    sorted_dictionary = dict(sorted(dictionary.items(), key=lambda item: item[1],reverse=True))

    # count = 0
    total = 0
    list = []
    for item in sorted_dictionary:
        # print(f"{item} {sorted_dictionary[item]}")
        # count+=1
        total += sorted_dictionary[item]
        list.append(sorted_dictionary[item]) 
        # if count >= 10:
        #     break

    best_devision = total/len(sorted_dictionary)
    total_dif = 0

    for item in sorted_dictionary:
        per = sorted_dictionary[item]/total*100
        dif = per/best_devision*100
        # print(f"Diff:{dif}%")
        total_dif += dif



    a = np.array(list[0:10])
    num_std = np.std(a)
    spread = total_dif / len(sorted_dictionary) *100

    print(f"total:{spread}, num std: {num_std}")
    
def set_spoken_value(item, dictionary, spoken_value):
    if item not in dictionary:
        dictionary[item] = spoken_value
        return
    
    current_value = dictionary[item]
    if current_value < spoken_value:
        dictionary[item] = spoken_value


if __name__ == '__main__':

    glosses = []
    translations = []

    db_file =r"./Data/signbank.db"
    conn = None

    f = open(r"./Data/totrank.txt", "r")
    lines = f.readlines()

    locations = {}
    movement = {}
    handshapes = {}

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
                    
                    set_spoken_value(gloss[1], locations, spoken_amount)
                    set_spoken_value(gloss[2], movement, spoken_amount)
                    set_spoken_value(gloss[3], handshapes, spoken_amount)

                except KeyError as key_error:
                    count += 1

        print("Locations:")
        # print_ten_most_used(locations)

        # test = [1742, 207, 167, 151, 143, 143, 97, 81, 78, 70]
        # std1 =np.std(np.array(test))
        # r1=np.ptp(np.array(test))
        # print(std1)
        # print(r1)
        # print(std1 * r1)
        #
        # print("Movement:")
        # # print_ten_most_used(movement)
        #
        # test2 = [482, 426,311,201,131, 122, 77, 64, 55, 51]
        # std2 =np.std(np.array(test2))
        # r2=np.ptp(np.array(test2))
        # print(std2)
        # print(r2)
        # print(std2 * r2)
        #
        # print("Handshapes:")
        # # print_ten_most_used(handshapes)
        #
        # test3 = [580,403,293,285,183,173,162,141,132,131]
        # std3 =np.std(np.array(test3))
        # r3=np.ptp(np.array(test3))
        # print(std3)
        # print(r3)
        # print(std3 * r3)

        test1 = [50]

        for x in range(50):
            test1.append(1)
            
        print("test1")
        std1 =np.std(np.array(test1))
        r1=np.ptp(np.array(test1))
        print(std1)
        print(r1)
        print(std1 * r1)

        test2 = [35,30,25,10]

        print("test2")
        std2 =np.std(np.array(test2))
        r2=np.ptp(np.array(test2))
        print(std2)
        print(r2)
        print(std2 * r2)


        print(f"Number of unmatched words {count}")
    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()
