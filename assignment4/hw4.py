import sqlite3
import csv  # Use this to read the csv file
from _datetime import datetime

def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by the db_file
    Parameters
    ----------
    Connection
    """
    con = sqlite3.connect(db_file)
    return con


def update_employee_salaries(conn, increase):
    """

    Parameters
    ----------
    conn: Connection
    increase: float
    """
    with conn:
        cur = conn.cursor()
        query ="SELECT E.EID, CE.SalaryPerDay FROM Employee as E JOIN ConstructorEmployee as CE ON E.EID = CE.EID WHERE ((SELECT (cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', E.BirthDate) as int)))  >= 50)"
        cur.execute(query)
        rows = cur.fetchall()
        for row in rows:
            id = row[0]
            salary = row[1]
            new_salary = salary*(1+(increase/100))
            cur.execute('UPDATE ConstructorEmployee SET SalaryPerDay=? WHERE EID = ?', (new_salary, id))

def get_employee_total_salary(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    int
    """
    total = 0
    with conn:
        cur = conn.cursor()
        cur.execute('SELECT sum(SalaryPerDay) FROM ConstructorEmployee')
        res = cur.fetchone()
        total = res[0]
    return int(total)


def get_total_projects_budget(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    float
    """
    total = 0
    with conn:
        cur = conn.cursor()
        cur.execute('SELECT sum(Budget) FROM Project')
        res = cur.fetchone()
        total = res[0]
    return float(total)


def calculate_income_from_parking(conn, year):
    """
    Parameters
    ----------
    conn: Connection
    year: str

    Returns
    -------
    float
    """
    total = 0
    with conn:
        cur = conn.cursor()
        cur.execute("SELECT sum(Cost) FROM (SELECT Cost FROM CarParking as CP WHERE strftime('%Y',CP.StartTime) = ?)", (year,))
        res = cur.fetchone()
        total = res[0]
    return float(total)


def get_most_profitable_parking_areas(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    arr = list()
    with conn:
        cur = conn.cursor()
        cur.execute("SELECT PA.AID , sum(Cost) as Cost FROM ParkingArea as PA JOIN CarParking as CP ON PA.AID = CP.AID GROUP BY PA.AID ORDER BY Cost DESC, PA.AID DESC")
        records = cur.fetchall()
        for row in records:
            arr.append(row)
        res = arr[:5]
        return res


def get_number_of_distinct_cars_by_area(conn):
    """
    Parameters
    ----------
    conn: Connection

    Returns
    -------
    list[tuple]

    """
    arr = list()
    with conn:
        cur = conn.cursor()
        cur.execute( "SELECT PA.AID ,count(DISTINCT CID) as Amount FROM ParkingArea as PA JOIN CarParking as CP ON PA.AID = CP.AID GROUP BY PA.AID ORDER BY Amount DESC")
        records = cur.fetchall()
        for row in records:
            arr.append(row)
        return arr


def add_employee(conn, eid, firstname, lastname, birthdate, street_name, number, door, city):
    """
    Parameters
    ----------
    conn: Connection
    eid: int
    firstname: str
    lastname: str
    birthdate: datetime
    street_name: str
    number: int
    door: int
    city: str
    """
    with conn:
        cur = conn.cursor()
        cur.execute('INSERT INTO Employee VALUES (?,?,?,?,?,?,?,?)', (eid,firstname,lastname,birthdate,street_name,number,door,city))


def load_neighborhoods(conn, csv_path):
    """

    Parameters
    ----------
    conn: Connection
    csv_path: str
    """
    with conn:
        cur = conn.cursor()
        with open(csv_path) as csv_file:
            csv_reader = csv.reader(csv_file, delimiter='\n')
            for row in csv_reader:
                line = row[0]
                arr = line.split(',')
                id = arr[0]
                name = arr[1]
                cur.execute('INSERT INTO Neighborhood(NID,Name) VALUES (?,?)', (id, name))

