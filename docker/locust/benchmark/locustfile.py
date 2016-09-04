from locust import HttpLocust, TaskSet
import random, uuid, time

useragents = open("/benchmark/useragents").readlines()
urls = open("/benchmark/urls").readlines()
ips = open("/benchmark/ips").readlines()
tracker_ids = []
visitors = []

for num in range(1, 2000):
    tracker_ids.append(uuid.uuid4().__str__())


def random_useragent():
    return random.choice(useragents).strip()


def random_url():
    return random.choice(urls).strip()


def random_tracker_id():
    return random.choice(tracker_ids)


def random_ip():
    return random.choice(ips).strip()


def random_params():
    return {
        "e":"pageView",
        "l":"pl",
        "t":random_tracker_id(),
        "de":"UTF-8",
        "dl":random_url(),
        "sr":"1674x557",
        "sv":"1680x1050",
        "cd":24,
        "di":random_di(),
        "dt":"lorem ipsum lorem",
        "cb":uuid.uuid4().__str__(),
        "vid":uuid.uuid4().__str__(),
        "sid":uuid.uuid4().__str__(),
        "st":str(int(time.time() * 1000)) + "." + str(int(time.time() * 1000)) + "." + str(int((time.time()) + 1800) * 1000) + "." + str(int(time.time() * 1000))
    }

def random_di():
        di = "1"
        for x in range(1, 13):
            di = di + str(int(random.getrandbits(1)))
        return hex(int(di, 2))

def visits(l):
    params = random_params()
    headers = {
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Language": "en-US,en;q=0.5",
        "Connection": "keep-alive",
        "Content-Type": "application/json",
        "User-Agent": random_useragent(),
        "X-Forwarded-For": random_ip()
    }

    response = l.client.get("/", **{
        "params": params,
        "headers": headers
    })

    visitors.append({
        "params": params,
        "headers": headers,
        "cookies": response.cookies
    })


def revisits(l):
    if len(visitors) > 2000:
        del visitors[:]
    if len(visitors) > 0:
        revisit = random.choice(visitors)

        params = revisit["params"]
        params["dl"] = random_url()

        st = params["st"].split(".")

        params["st"] = st[0] + "." + st[1] + "." + str(int((time.time()) + 1800) * 1000) + "." + str(int(time.time() * 1000))

        l.client.get("/", **{
            "params": params,
            "headers": revisit["headers"],
            "cookies": revisit["cookies"]
        })


class UserBehavior(TaskSet):
    tasks = {visits: 1, revisits: 2}


class WebsiteUser(HttpLocust):
    task_set = UserBehavior
