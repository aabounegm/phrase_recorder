import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from argparse import ArgumentParser
from csv import DictReader


parser = ArgumentParser(description='Manages the phrases added to Firestore')
subparser = parser.add_subparsers(dest='cmd')
subparser.add_parser('add_simple_phrases').add_argument('path')
subparser.add_parser('add_audio_chapters').add_argument('path')
subparser.add_parser('populate_audio_chapters').add_argument('path')
subparser.add_parser('clear').add_mutually_exclusive_group()
parser.add_argument('--serviceAccount',
    metavar='path/to/serviceAccount.json',
    help='Path to the service account JSON file',
    default='serviceAccount.json',
)

args = parser.parse_args()

cred = credentials.Certificate(args.serviceAccount)
firebase_admin.initialize_app(cred)
db = firestore.client()

# lesson_id	audio_id text_ar_vowels text_ar

if args.cmd == 'add_simple_phrases':
    with open(args.path, encoding='utf-8') as f:
        reader = DictReader(f)
        batch = db.batch()
        for row in reader:
            ref = db.collection('phrases').document(row['audio_id'])
            batch.set(ref, {
                'text': row['text_ar_vowels'],
                'text_no_vowels': row['text_ar']
            })
        results = batch.commit()
        print(f'Added {len(results)} phrases to Firestore')
elif args.cmd == 'add_audio_chapters':
    with open(args.path, encoding='utf-8') as f:
        reader = DictReader(f)
        batch = db.batch()
        for row in reader:
            ref = db.collection('chapters').document(row['id'])
            batch.set(ref, {
                'title': row['title'],
                'subtitle': row['subtitle'],
                'commentary': row['commentary']
            })
        results = batch.commit()
        print(f'Added {len(results)} chapter(s) to Firestore')
elif args.cmd == 'populate_audio_chapters':
    with open(args.path, encoding='utf-8') as f:
        reader = DictReader(f)
        batch = db.batch()
        for row in reader:
            ref = db.collection('chapters').document(row['parentId']).collection('phrases').document(row['id'])
            batch.set(ref, {
                'text': row['uthmani'],
                'index': row['index']
            })
        results = batch.commit()
        print(f'Added {len(results)} audio phrases to Firestore')
elif args.cmd == 'clear':
    docs = db.collection('phrases').stream()
    count = 0
    for doc in docs:
        doc.reference.delete()
        count += 1
        print(f'Deleted {count} phrases', end='\r')
    print(f'Deleted {count} phrases')
else:
    parser.print_usage()
    exit()
