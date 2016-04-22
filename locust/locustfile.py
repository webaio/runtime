from locust import HttpLocust, TaskSet
import random, uuid

useragents = open("useragents").readlines()
urls = open("urls").readlines()
ips = open("ips").readlines()
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
        "u": random_url(),
        "t": random_tracker_id(),
        "e": 0,
        "w": 1280,
        "h": 960,
        "aw": 1280,
        "ah": 960,
        "d1": int(random.getrandbits(1)),
        "d2": int(random.getrandbits(1)),
        "d3": int(random.getrandbits(1)),
        "d4": int(random.getrandbits(1)),
        "d5": int(random.getrandbits(1)),
        "d6": int(random.getrandbits(1)),
        "d7": int(random.getrandbits(1)),
        "d8": int(random.getrandbits(1)),
        "d9": int(random.getrandbits(1)),
        "d10": int(random.getrandbits(1)),
        "d11": int(random.getrandbits(1)),
        "d12": int(random.getrandbits(1)),
        "d13": int(random.getrandbits(1)),
        "d14": int(random.getrandbits(1))
    }


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
        params["u"] = random_url()

        l.client.get("/", **{
            "params": params,
            "headers": revisit["headers"],
            "cookies": revisit["cookies"]
        })


class UserBehavior(TaskSet):
    tasks = {visits: 2, revisits: 1}


class WebsiteUser(HttpLocust):
    task_set = UserBehavior
