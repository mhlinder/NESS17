#!/usr/bin/python
print 'please contact henry before running this script'
import sys
sys.exit()

def write(f, s):
    f.write(s + '\n')
    
def new_para(f):
    f.write('\n')

def bf(s):
    return '{\\bf ' + s + '}'

def emph(s):
    return '\emph{' + s + '}'

def escape(s):
    s = s.replace('&', '\\&')
    return s

from abstract_utils import get_abstracts
(sessions, posters) = get_abstracts()


sessionlist = {'01' : {'Title' : 'Statistical Methods and Computing with Big Data',
                       'Organizers' : ['John Emerson', 'Jun Yan'],
                       'Morning' : False,
                       'Location' : '102'},
               '02' : {'Title' : 'Statistical Applications and Practice',
                       'Organizers' : ['Xiaojing Wang', 'Jun Yan'],
                       'Morning' : False,
                       'Location' : '105'},
               '03' : {'Title' : 'Frontiers in Sequential Analysis with Applications',
                       'Organizers': ['Aleksey Polunchenko'],
                       'Morning' : True,
                       'Location' : '103'},
               '04' : {'Title' : 'Statistical Challenges in Modeling and Applications',
                       'Organizers' : ['Erin Conlon'],
                       'Morning' : True,
                       'Location' : '202'},
               '05' : {'Title' : 'Statistical Innovations in Biomedical Research',
                       'Organizers': ['Yuping Zhang',  'Hongyu Zhao'],
                       'Morning' : True,
                       'Location' : '102'},
               '06' : {'Title' : 'Recent Advances in Subgroup Analyses',
                       'Organizers' : ['Xiaojing Wang'],
                       'Morning' : False,
                       'Location' : '103'},
               '07' : {'Title' : 'Recent Advances in Spatial Statistics',
                       'Organizers' : ['Cici Bauer'],
                       'Morning' : True,
                       'Location' : '445'},
               '08' : {'Title' : 'Pharmaceutical Applications',
                       'Organizers' : ['Daniel Meyer'],
                       'Morning' : False,
                       'Location' : '108'},
               '09' : {'Title' : 'Statistical Inference in Time Series and Machine Learning',
                       'Organizers' : ['Luis Carvalho'],
                       'Morning' : True,
                       'Location' : '163'},
               '10' : {'Title' : 'Design and Analysis of Complex Experiments',
                       'Organizers' : ['Edoardo Airoldi'],
                       'Morning' : False,
                       'Location' : '202'},
               '11' : {'Title' : 'Association and Correlation Analysis for Big Data',
                       'Organizers' : ['Kun Chen', 'Jian Zou'],
                       'Morning' : False,
                       'Location' : '110'},
               '12' : {'Title' : 'Career Development',
                       'Organizers' : ['Naitee Ting'],
                       'Morning' : False,
                       'Location' : '445'},
               '13' : {'Title' : 'Advances in Statistical Genetics and Molecular Evolution',
                       'Organizers' : ['Lynn Kuo', 'Zheyang Wu'],
                       'Morning' : False,
                       'Location' : '164'},
               '14' : {'Title' : 'Data Analytics at IBM Research',
                       'Organizers' : ['Yasuo Amemiya'],
                       'Morning' : False,
                       'Location' : '163'},
               '15' : {'Title' : 'Latest Developments in Analyzing Survival Endpoint Methods After Taking Alternative Therapy/Treatment Switching in Oncology Trials',
                       'Organizers' : ['Huyuan Yang', 'ICSA'],
                       'Morning' : True,
                       'Location' : '434'},
               '16' : {'Title' : 'Evarist Gin\\\'{e}---in memory',
                       'Organizers' : ['Rick Vitale'],
                       'Morning' : False,
                       'Location' : '434'}
           }

times = ['11:00am--12:45pm', '3:30pm--5:15pm']
texnl = '\\\\'

with open('tex/programsessions.tex', 'w') as f1, open('tex/morning.tex', 'w') as f2, open('tex/afternoon.tex', 'w') as f3, open('tex/abstracts.tex', 'w') as f4, open('tex/posters.tex', 'w') as f5:
    # output sessions
    morning = {s: sessionlist[s] for s in sessionlist if sessionlist[s]['Morning']}
    afternoon = {s: sessionlist[s] for s in sessionlist if not sessionlist[s]['Morning']}
    i = 1
    for time in [morning, afternoon]:
        if i > 1:
            i += 3
        for skey in sorted(time.keys()):
            session = time[skey]
            papers = sessions[skey]
            if skey == '16':
                papers.append({'Abstract' : '''Originally from Catalonia, Evarist arrived at MIT as a graduate student in 1970. He taught me from early on distinctions between Catalan and Spanish.

                He finished his Ph.D. thesis (on testing for uniformity in compact Riemannian manifolds) in 1973 and published it in Annals of Statistics in 1975. After he took a job at Storrs much later, we began to have joint seminars at different campuses in southern New England and still later, mainly alternating between MIT and Storrs. Besides mathematics, I'll mention a hike up Mt Monadnock in May 2007 by several friends from the seminar where we saw a lot of a remarkable flower, \\emph{Rhodora}.

Among the topics of joint interest later on were: centeral limit theorems in Banach spaces and the bootstrap.''',
                               'Authors' : [{'Affiliation' : 'MIT', 'Email' : '', 'Name' : 'R.M. Dudley'}],
                               'ID' : '',
                               'Primary' : 1,
                               'Title' : 'Evarist as student, teacher, and friend'})
            
            if session['Morning']:
                t = times[0]
                fh = f2
            else:
                t = times[1]
                fh = f3

            ref = skey;
            # add to schedule
            write(fh, '& %s: %s %s' % (bf('Session %d' % i), session['Title'], texnl))
            write(fh, '& AUST %s %s' % (session['Location'], texnl))
            write(fh, '\\addlinespace[1em]')

            # add detailed schedule
            # session name
            write(f1, bf('Session %d: %s %s' % (i, session['Title'], texnl)))
            # time and location
            write(f1, '%s: %s in AUST %s %s' % (bf('Time and Location'), t, session['Location'], texnl))
            # organizers
            write(f1, '%s: %s' % (bf('Organizers'), ' and '.join(session['Organizers'])))
            new_para(f1)

            # fill in detailed schedule, abstracts
            if len(papers) > 0:
                write(f4, '\\subsection*{%s}' % bf('Session %d: %s' % (i, session['Title'])))
                write(f4, '\\label{%s}' % ref)
                write(f1, 'Talks (abstracts on page \\pageref{%s}):' % ref)
                write(f1, '\\begin{enumerate}')
                for paper in papers:
                    write(f1, '\\item %s %s' % (paper['Title'], texnl))
                    presenter = paper['Authors'][paper['Primary']-1]
                    write(f1, '%s, %s' % (bf(presenter['Name']), emph(escape(presenter['Affiliation']))))

                    # abstract text
                    write(f4, bf(paper['Title']))
                    new_para(f4)
                    for author in paper['Authors']:
                        write(f4, '%s, %s %s' % (author['Name'], emph(escape(author['Affiliation'])), texnl))
                    new_para(f4)
                    write(f4, paper['Abstract'] + texnl)
                    new_para(f4)

                if skey == '16':
                    write(f1, '\\item Remarks %s' % texnl)
                    write(f1, bf('Molly Hahn, Rick Vitale, others'))
                write(f1, '\\end{enumerate}')
            
            new_para(f1)
            i += 1

    # output posters
    p1 = posters[:20]
    p2 = posters[20:40]
    p3 = posters[40:]
    i = 1
    locs = ['105', '108', '110']
    for pses in [p1, p2, p3]:
        title = 'Boehringer Ingelheim and Travelers Sponsered Poster Session %s' % (i*'I')
        no = 6+i
        ref = 'posters%d' % i
        
        write(f2, '& %s: %s %s' % (bf('Session %d' % no), title, texnl))
        write(f2, '& AUST %s %s' % (locs[i-1], texnl))
        write(f2, '\\addlinespace[1em]')

        write(f1, bf('Session %d: %s %s' % (no, title, texnl)))
        write(f1, '%s: %s in AUST %s %s' % (bf('Time and Location:'), times[0], locs[i-1], texnl))
        new_para(f1)

        write(f1, 'Posters (abstracts on page \\pageref{%s}):' % ref)
        write(f1, '\\begin{enumerate}')

        write(f5, '\\subsection*{%s}' % bf('Session %d: %s' % (i, title)))
        write(f5, '\\label{%s}' % ref)
        for poster in pses:
            write(f1, '\\item %s %s' % (poster['Title'], texnl))
            presenter = poster['Authors'][poster['Primary']-1]
            write(f1, '%s, %s' % (bf(presenter['Name']), emph(escape(presenter['Affiliation']))))

            write(f5, bf(poster['Title']))
            new_para(f5)
            for author in poster['Authors']:
                write(f5, '%s, %s %s' % (author['Name'], emph(escape(author['Affiliation'])), texnl))
            new_para(f5)
            write(f5, escape(poster['Abstract']) + texnl)
            new_para(f5)
        write(f1, '\\end{enumerate}')
        new_para(f1)
        
        i += 1
