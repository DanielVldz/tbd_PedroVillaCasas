import requests
import urllib.request
import re
import csv
from bs4 import BeautifulSoup

tipos = []
lista_poke = []
datosPoke = []

def validarGen(poke):
    for i in range(1, len(lista_poke)):
        if (lista_poke[i].lower() in poke.lower()):
            if("mega" not in poke.lower()):
                return True
            break
    return False


def getPokeID(poke):
    for i in range(1, len(lista_poke)):
        if(lista_poke[i].lower() in poke.lower()):
            return i


def escribirCSV(rutaCSV, renglon):
    with open(rutaCSV, 'a', encoding='utf-8') as csvFile:
        writer = csv.writer(csvFile, delimiter=';', lineterminator='\n')
        writer.writerow(renglon)
    csvFile.close()


def getTiposID(tipo_ataque):
    for j in range(18):
        if tipo_ataque.capitalize() == tipos[j][1]:
            tipo_ataque = (tipos[j][0] + 1)
            break
    return tipo_ataque


def obtenerNombres(soup):
    lista_poke = []

    for i in range(0, len(soup.find_all('h2')) - 4):
        lista_poke.append(soup.find_all('h2')[i].text[:-8])
        print(lista_poke[i])

    return lista_poke


def obtenerDatosPoke(soup, lista_pokemon):

    corrimiento = 0
    nivel_evolucion = 0
    datos = [None]
    csv = "Bichos/Evoluciones.csv"
    for i in range(0, len(soup.find_all('td')), 4):

        numero_actual = soup.find_all('td')[i + corrimiento].text.split(':')
        evolucion_anterior = soup.find_all(
            'td')[i + 2 + corrimiento].text.split(':')
        regex = re.compile(
            "(nivel ([1|2|3|4|5|6|7|8|9]*[0|1|2|3|4|5|6|7|8|9]))")

        if "No evoluciona" in evolucion_anterior[0]:
            evolucion_anterior = " null"
            evolucion_siguiente1 = " null"
            corrimiento = corrimiento - 1
            nivel_evolucion = "null"

        else:
            evolucion_siguiente1 = soup.find_all(
                'td')[i + 3 + corrimiento].text.split(':')

            # Si evoluciona por amistad o no es de esta gen, cuello
            if(("amistad" in evolucion_anterior[1]) or not validarGen(evolucion_anterior[1])):
                evolucion_anterior = " null"
                id_anterior = "null"
            else:
                evolucion_anterior = evolucion_anterior[1]
                id_anterior = getPokeID(evolucion_anterior)


            # Lo mismo
            if ("amistad" in evolucion_siguiente1[1]) or not validarGen(evolucion_siguiente1[1]):
                evolucion_siguiente1 = "null"
                id_siguiente = "null"
                nivel_evolucion = "null"
            else:
                evolucion_siguiente1 = evolucion_siguiente1[1]
                id_siguiente = getPokeID(evolucion_siguiente1)
                try:
                    nv = regex.search(evolucion_siguiente1)
                    nivel_evolucion = nv.group(2)
                except:
                    nivel_evolucion = "null"

        # nombre_actual = lista_poke[int(numero_actual[1])]
        nombre_actual = lista_pokemon[0]
        id_actual = getPokeID(nombre_actual)
        print("Poke actual", nombre_actual)
        print("Evoluciona de: ", id_anterior, " : ", evolucion_anterior)
        print("Nivel evolucion ", nivel_evolucion)
        print("Evoluciona a: ", id_siguiente, " : ", evolucion_siguiente1)
        datos.append([nombre_actual, nivel_evolucion])
        
        if(id_anterior != "null"):
            evolucion = [id_anterior, id_actual]
            escribirCSV(csv, evolucion)
    datos.insert(5, ["Charizard", "null", "null", 5])
    return datos


def obtenerDetallePokemon(soup, lista_poke):
    url = "https://pokemon.fandom.com/es/wiki/"
    csv = "Bichos/Bichos.csv"
    for i in range(1, len(lista_poke) - 1):
        if(lista_poke[i] != "Farfetch’d"):
            url_actual = url + (lista_poke[i].replace(' ', '_'))
        else:
            url_actual = "https://pokemon.fandom.com/es/wiki/Farfetch%27d"
        response = requests.get(url_actual)
        soup = BeautifulSoup(response.text, "html.parser")
        # Se requieren:
        # Velocidad, Salud máxima, daño de ataque y descripción

        # TD's : ps - 6, ataque - 7 y velocidad - 11
        #tabla_stats = soup.find("table", class_="estadisticas")

        Descripcion = soup.find("table", class_="pokedex radius10").find_all("tr")[
            9].find("td").text.replace('\r', '').replace('\n', '')

        ratio_captura = soup.find("div", class_="otrosdatos sombra radius10").find_all(
            "li")[1].text.replace('\r', '').replace('\n', '').split()

        tipo1 = soup.find("div", {"data-source": "tipo1"}).find_all(
            "img")[0].get("alt").replace('\r', '').replace('\n', '').split()
        tipo1 = getTiposID(tipo1[1])
        try:
            tipo2 = soup.find("div", {"data-source": "tipo1"}).find_all(
                "img")[2].get("alt").replace('\r', '').replace('\n', '').split()
            tipo2 = getTiposID(tipo2[1])
        except:
            tipo2 = "null"

        # Estadísticas base
        ps_base = soup.find("table", class_="estadisticas").find_all(
            'td')[6].next_element.replace('\r', '').replace('\n', '')
        ataque_base = soup.find("table", class_="estadisticas").find_all(
            'td')[7].next_element.replace('\r', '').replace('\n', '')
        defensa_base = soup.find("table", class_="estadisticas").find_all('td')[
            8].next_element.replace('\r', '').replace('\n', '')
        ataque_especial_base = soup.find("table", class_="estadisticas").find_all('td')[
            9].next_element.replace('\r', '').replace('\n', '')
        defensa_especial_base = soup.find("table", class_="estadisticas").find_all(
            'td')[10].next_element.replace('\r', '').replace('\n', '')
        velocidad_base = soup.find("table", class_="estadisticas").find_all('td')[
            11].next_element.replace('\r', '').replace('\n', '')

        # Estadísticas máximas con naturaleza neutra
        ps_maximo = soup.find("table", class_="estadisticas").find_all(
            'td')[18].next_element.replace('\r', '').replace('\n', '')
        ataque_maximo = soup.find("table", class_="estadisticas").find_all(
            'td')[19].next_element.replace('\r', '').replace('\n', '')
        defensa_maxima = soup.find("table", class_="estadisticas").find_all('td')[
            20].next_element.replace('\r', '').replace('\n', '')
        ataque_especial_maximo = soup.find("table", class_="estadisticas").find_all(
            'td')[21].next_element.replace('\r', '').replace('\n', '')
        defensa_especial_maxima = soup.find("table", class_="estadisticas").find_all(
            'td')[22].next_element.replace('\r', '').replace('\n', '')
        velocidad_maxima = soup.find("table", class_="estadisticas").find_all('td')[
            23].next_element.replace('\r', '').replace('\n', '')

        print("Poke: ", lista_poke[i])
        print("Descripción: ", Descripcion)
        print("Tipo 1: ", tipo1)
        print("Tipo 2: ", tipo2)
        print("Ratio de captura: ", ratio_captura[3])
        print("Puntos de salud base: ", ps_base)
        print("Ataque normal base: ", ataque_base)
        print("Defensa base: ", defensa_base)
        print("Ataque especial base: ", ataque_especial_base)
        print("Defensa especial base: ", defensa_especial_base)
        print("Velocidad base: ", velocidad_base)
        print("Puntos de salud máximos: ", ps_maximo)
        print("Ataque normal máximo: ", ataque_maximo)
        print("Defensa máxima: ", defensa_maxima)
        print("Ataque esppecial máximo: ", ataque_especial_maximo)
        print("Defensa especial máxima: ", defensa_especial_maxima)
        print("Velocidad máxima: ", velocidad_maxima)

        renglon = [i, 
                lista_poke[i], 
                Descripcion, 
                tipo1, 
                tipo2, 
                datosPoke[i][1], 
                ratio_captura[3], 
                ps_base,
                ataque_base, 
                defensa_base, 
                ataque_especial_base, 
                defensa_especial_base, 
                velocidad_base,
                ps_maximo, 
                ataque_maximo, 
                defensa_maxima, 
                ataque_especial_maximo, 
                defensa_especial_maxima, 
                velocidad_maxima]
        print(renglon)

        escribirCSV(csv, renglon)


def obtenerTipos(soup):
    url = 'https://pokemon.fandom.com/es/wiki/Tipos_elementales'
    csv = "Bichos/Tipos.csv"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    lista_tipos = []
    id_tipo = 0

    for i in range(0, 36, 2):
        tipo_actual = soup.find_all('td')[i].text.replace(
            '\r', '').replace('\n', '')
        lista_tipos.append([id_tipo, str(tipo_actual)])
        id_tipo += 1
        
        renglon = [id_tipo, tipo_actual]

        #escribirCSV(csv, renglon)

    print(lista_tipos)
    return lista_tipos


def obtenerAtaques(soup, tipos):

    url = 'https://pokemon.fandom.com/es/wiki/Lista_de_movimientos_por_generaci%C3%B3n'
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    ataques = []

    for i in range(37, 857, 5):
        ataque_actual = soup.find_all('td')[i].text.replace(
            '\n', '').replace('\r', '').replace('(1ª gen.)', '')
        ataques.append(ataque_actual)
        print("Ataque actual: ", ataque_actual)

    return ataques


def obtenerDetalleAtaques(soup, lista_ataques):
    # Ignorar para el CSV los que no tengan potencia
    url = "https://pokemon.fandom.com/es/wiki/"
    ataqueID = 0
    csv = "Bichos/Ataques.csv"
    for i in range(0, len(lista_ataques)):
        url_actual = url + (lista_ataques[i][1:].replace(' ', '_'))
        response = requests.get(url_actual)
        soup = BeautifulSoup(response.text, "html.parser")

        # Obtención de los datos del ataque actual
        print(lista_ataques[i])

        categoria = soup.find(
            "div", {"data-source": "categoría"}).find("img").get("alt")
        if "Tipo físico" in categoria:
            categoria = "f"
        elif "Tipo especial" in categoria:
            categoria = "e"
        else:
            categoria = None
        tipo = soup.find("div", {"data-source" : "tipo"}).find("img").get("alt").replace('\r', '').replace('\n', '').split()
        tipo = getTiposID(tipo[1])
        try:
            potencia = soup.find(
                "div", {"data-source": "potencia"}).find('div').next_element

        except:
            # El ataque no tiene Potencia, por lo tanto es una habilidad que aplica efectos
            potencia = None

        if (categoria != None) and (potencia != None and (potencia != "-")):
            ataqueID = ataqueID + 1
            renglon = [ataqueID, lista_ataques[i][1:], categoria, potencia, tipo]
            escribirCSV(csv, renglon)

        print("Categoría del ataque: ", categoria)
        print("Potencia del ataque", potencia)


def obtenerResistencias(soup):
    # Datos en matriz de 18 x 18
    csv = "Bichos/Resistencias.csv"
    url = 'https://pokemon.fandom.com/es/wiki/Tipos_elementales'
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    # 324
    for i in range(18, 342, 19):

        for j in range(1, 19, 1):
            tipo = soup.find("table", class_="lista").find_all('td')[i].find(
                'a').get('title').replace('\r', '').replace('\n', '').split()
            afectado = soup.find("table", class_="lista").find_all(
                'td')[j - 1].find('a').get('title').replace('\r', '').replace('\n', '').split()

            tipo = getTiposID(tipo[1])
            afectado = getTiposID(afectado[1])

            try:
                efecto = soup.find("table", class_="lista").find_all(
                    'td')[i + j].find('a').get('title').replace('\r', '').replace('\n', '')
                if(efecto == "Poco efectivo"):
                    efecto = .5
                elif(efecto == "Muy efectivo"):
                    efecto = 2
                else:
                    efecto = 0
            except:
                efecto = 1

            # print(tipo)
            # print(efecto)
            print("Un ataque tipo ", tipo, " x ", efecto, " a ", afectado)
            if efecto != 1:
                renglon = [tipo, efecto, afectado]
                escribirCSV(csv, renglon)

        print("Fin del renglón número: ", (i + 1))


url = 'https://es.wikipedia.org/wiki/Anexo:Pok%C3%A9mon_de_la_primera_generaci%C3%B3n'
response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")

direccion_csv = 'D:/Documentos/Escuela/Semestre 7/Taller de base de datos/Proyecto 1/Pokimon_primera_gen.csv'

tipos = obtenerTipos(soup)
#lista_poke = obtenerNombres(soup)
#datosPoke = obtenerDatosPoke(soup, lista_poke)  # Este
#obtenerDetallePokemon(soup, lista_poke)
lista_ataques = obtenerAtaques(soup, tipos)
obtenerDetalleAtaques(soup, lista_ataques)
#obtenerResistencias(soup)
print("Ya we")