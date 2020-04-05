const mine = {
	print(value) {
		console.log(value);
	},
	async sendRequestWithAuth(url, data, urlMethod) {
	  const fullUrl = 'https://jordan-app-test.herokuapp.com' + url;
      const response = await fetch(fullUrl, {
        method: urlMethod,
        mode: 'cors',
        cache: 'no-cache',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + JSON.parse(localStorage.userInfo).token
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer',
        body: JSON.stringify(data)
      }).then((res) => {
      	return res.json();
      });
      return await response;
    },
	async sendRequestWithoutAuth(url, data, urlMethod) {
	  const fullUrl = 'https://jordan-app-test.herokuapp.com' + url;
      const response = await fetch(fullUrl, {
        method: urlMethod,
        mode: 'cors',
        cache: 'no-cache',
        headers: {
          'Content-Type': 'application/json',
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer',
        body: JSON.stringify(data)
      }).then((res) => {
      	return res.json();
      });
      return await response;
    },
    async getRequestWithAuth(url) {
	  const fullUrl = 'https://jordan-app-test.herokuapp.com' + url;
      const response = await fetch(fullUrl, {
        method: 'GET',
        cache: 'no-cache',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + JSON.parse(localStorage.userInfo).token
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer',
      }).then((res) => {
      	return res.json();
      });
      return await response;
    },
    async getRequestWithoutAuth(url) {
	  const fullUrl = 'https://jordan-app-test.herokuapp.com' + url;
      const response = await fetch(fullUrl, {
        method: 'GET',
        cache: 'no-cache',
        headers: {
          'Content-Type': 'application/json',
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer',
      }).then((res) => {
      	return res.json();
      });
      return await response;
    },
    async sendRequestWithAuthNoRes(url, data, urlMethod) {
      const fullUrl = 'https://jordan-app-test.herokuapp.com' + url;
      const response = await fetch(fullUrl, {
        method: urlMethod,
        mode: 'cors',
        cache: 'no-cache',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + JSON.parse(localStorage.userInfo).token
        },
        redirect: 'follow',
        referrerPolicy: 'no-referrer',
        body: JSON.stringify(data)
      }).then((res) => {
      	return res.text();
      });
      return await response;
    },
}

export default mine;