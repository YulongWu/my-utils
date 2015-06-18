import httplib, urllib
import time
def hi_BLCU(account, upass, is_quit = False):
    params = urllib.urlencode({"DDDDD":account[0:account.find("%7C")], "upass":upass, "R1":0, "R2":1, "para":00, "OMKKey":123456})
    headers = {"Content-Type":"application/x-www-form-urlencoded", "Cookie":"tj_login=" + account}
    retry = 3
    while retry > 0:
        if is_quit:
            print "Quiting account {0}...".format(account)
            conn = httplib.HTTPConnection("192.168.200.2/F.htm", 80)
            conn.request("GET", "", "", headers)
        else:
            print "Registering account {0}...".format(account)
            conn = httplib.HTTPConnection("192.168.200.2", 80)
            conn.request("POST", "", params, headers)
        response = conn.getresponse()
        print "Response: ", response.status, response.reason
        conn.close()
        --retry
        if response.status == 200:
            break
    return response

if __name__ == "__main__":
    accounts = [("201421198101%7C671109", "a475a2a58909dfbc98512e51d84ca3b7123456781"), ("SS1298176%7C19900408", "b5927b78396d0ec9a9e3a969bf495727123456781"), ("BK1125109%7C002008", "aff69e5fe37f7217f570ee8d9e4149d3123456781"), ("SS1298232%7C11004+21jy", "f163d9e4b5a4c6d10c5a7f9af72a13ea123456781")]
    accounts_waiting = ["201421198213%7C011526"]
    accounts_hanging = [("201419600354%7C950303", "606d5bb3c8ea1a653855573e626aa51e123456781")]
    accounts_unlimited_up_bound = 0
    DURATION_ON_LIMITED_ACCOUNT = 600  #which means 10 minutes

    account_index = 0
    limited_account_start_time = -1
    while 1:
        conn = httplib.HTTPConnection("www.baidu.com")
        conn.request("GET", "")
        response = conn.getresponse()
        conn.close()
        if response.status == 302 or limited_account_start_time != -1 and int(time.time()) - limited_account_start_time > DURATION_ON_LIMITED_ACCOUNT:
            if response.status == 302:
                print "Offline now...".format(accounts[account_index])
            else:
                print "Duration is due.".format(accounts[account_index])
                response = hi_BLCU(accounts[account_index][0], accounts[account_index][1], is_quit = True)
                if response.status == 200:
                    print "Quiting successful!" 
            response = hi_BLCU(accounts[account_index][0], accounts[account_index][1])
            if(account_index < accounts_unlimited_up_bound):
                limited_account_start_time = -1
            else:
                limited_account_start_time = int(time.time())
            account_index = account_index+1 if account_index < len(accounts)-1 else 0  #update account
        elif response.status == 200:
            print "Baidu is online. 200 OK"
        else:
            print "Baidu is unknown. {0}".format(response.status)
        time.sleep(3)
