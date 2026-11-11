import requests
import json

def upload_to_installonair(ipa_path):
    url = "https://www.installonair.com/api/upload"
    
    with open(ipa_path, 'rb') as f:
        files = {'file': f}
        data = {
            'api_token': 'YOUR_API_TOKEN',
            'name': 'Alien X Mobile',
            'version': '1.0',
            'bundle_id': 'com.alienx.mobile'
        }
        
        response = requests.post(url, files=files, data=data)
        
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Upload successful!")
            print(f"📲 Install link: {result['install_url']}")
            print(f"🔗 Direct link: {result['direct_url']}")
            return result['install_url']
        else:
            print(f"❌ Upload failed: {response.text}")
            return None

if __name__ == "__main__":
    upload_to_installonair("AlienX_Mobile_v1.0.ipa")