import requests
import os

def getSurah():
    os.makedirs("assets/datas/surah", exist_ok=True)

    for surah in range(1, 115):  # 1 sampai 114
        print(f"Sedang download surah {surah}...")
        resp = requests.get(f'https://equran.id/api/surat/{surah}')
        
        if resp.status_code == 200:
            with open(f'assets/datas/surah/{surah}.json', 'w', encoding='utf-8') as f:
                f.write(resp.text)
        else:
            print(f"Gagal download surah {surah}, status: {resp.status_code}")

getSurah()
