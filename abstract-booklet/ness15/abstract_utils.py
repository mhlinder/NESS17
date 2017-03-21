#!/usr/bin/python
from glob import iglob
from collections import defaultdict

def get_abstracts():
    sessionlist = {'00' : 'None',
                   '01' : 'Statistical Methods and Computing with Big Data (organized by John Emerson and Jun Yan)',
                   '02' : 'Statistical Applications and Practice (organized by Xiaojing Wang and Jun Yan)',
                   '03' : 'Frontiers in Sequential Analysis with Applications (organized by Aleksey Polunchenko)',
                   '04' : 'Statistical Challenges in Modeling and Applications (organized by Erin Conlon)',
                   '05' : 'Statistical Innovations in Biomedical Research (organized by Yuping Zhang and Hongyu Zhao)',
                   '06' : 'Recent Advances in Subgroup Analyses (organized by Xiaojing Wang)',
                   '07' : 'Recent Advances in Spatial Statistics (organized by Cici Bauer)',
                   '08' : 'Pharmaceutical Applications (organized by Daniel Meyer)',
                   '09' : 'Statistical Inference in Time Series and Machine Learning (organized by Luis Carvalho)',
                   '10' : 'Design and Analysis of Complex Experiments (organized by Edoardo Airoldi)',
                   '11' : 'Association and Correlation Analysis for Big Data (organized by Kun Chen and Jian Zou)',
                   '12' : 'Career Development (organized by Naitee Ting)',
                   '13' : 'Advances in Statistical Genetics and Molecular Evolution (organized by Lynn Kuo and Zheyang Wu)',
                   '14' : 'Data Analytics at IBM Research (organized by Yasuo Amemiya)',
                   '15' : 'Latest Developments in Analyzing Survival Endpoint Methods After Taking Alternative Therapy/Treatment Switching in Oncology Trials (organized by Huyuan Yang and ICSA)',
                   '16' : 'Probability and Related Topics -- in memory of Evarist Gine (organized by Rick Vitale)'}

    datadir = 'abstracts-saved/'
    delim = '@@$$@@$$@@'

    sessions = defaultdict(list)
    posters = list()
    for file in iglob(datadir + '*'):
        with open(file, 'r') as f:
            # read file
            lines = [line.strip() for line in f.readlines()]
            # poster or paper
            type = lines[0]
            # session number
            session = lines[2]
            # remove type, session number fields
            lines = lines[4:]
            # find delimiter
            dix = lines.index(delim)
            # make title into a single string
            title = ' '.join(lines[:dix])
            # remove title field
            lines = lines[dix+1:]

            authors = lines[:lines.index(delim)]
            nauth = len(authors) / 4
            authorlist = []
            fields = ['Name', 'Affiliation', 'Email']
            for i in xrange(nauth):
                auth = authors[(i*4):((i+1)*4)][:3]
                authorlist.append(dict(zip(fields, auth)))

            # remove author fields
            lines = lines[nauth*4+1:]

            # primary author
            primary = lines[0]
            lines = lines[2:]

            # abstract text
            abstracttext = "\n".join(lines)
        
            abstract = {'Authors' : authorlist,
                        'ID'      : file.split('/')[-1][:-4],
                        'Primary' : int(primary),
                        'Title'   : title,
                        'Abstract': abstracttext}

            if type == 'invited':
                # sessions[sessionlist[session]].append(abstract)
                sessions[session].append(abstract)
            elif type == 'poster':
                posters.append(abstract)
            else:
                print 'error!'

    return (sessions, posters)

# (sessions, posters) = get_abstracts()
# for session in sessions.keys():
#     print ' '
#     print '---- ' + session + ' ----'
#     papers = sessions[session]
#     for paper in papers:
#         print paper['Title'] + ' (' + ', '.join([author['Name'] for author in paper['Authors']]) + ')'
