import requests
import time

def upload_to_diawi(ipa_path):
    url = "https://upload.diawi.com/"
    
    with open(ipa_path, 'rb') as f:
        files = {'file': f}
        data = {'password': '', 'wall_off': '0'}
        
        response = requests.post(url, files=files, data=data)
        
        if response.status_code == 200:
            job_id = response.json().get('job')
            print(f"Upload job: {job_id}")
            
            time.sleep(5)
            
            check_url = f"https://upload.diawi.com/status?job={job_id}"
            result = requests.get(check_url).json()
            
            if result.get('status') == 2000:
                print(f"✅ Upload successful!")
                print(f"📲 Install link: {result['link']}")
                print(f"⏰ Link expires in 24 hours")
                return result['link']
            else:
                print(f"❌ Upload failed: {result}")
                return None
        else:
            print(f"❌ Upload failed: {response.status_code}")
            return None

if __name__ == "__main__":
    upload_to_diawi("AlienX_Mobile_v1.0.ipa")