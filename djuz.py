import requests
import os

def getJuz():
    os.makedirs("assets/datas/juz", exist_ok=True)

    for juz in range(1, 31):  # 1 sampai 30
        print(f"Sedang download Juz {juz}...")
        resp = requests.get(f'https://api.quran.gading.dev/juz/{juz}')
        
        if resp.status_code == 200:
            with open(f'assets/datas/juz/{juz}.json', 'w', encoding='utf-8') as f:
                f.write(resp.text)
        else:
            print(f"Gagal download Juz {juz}, status: {resp.status_code}")

getJuz()
