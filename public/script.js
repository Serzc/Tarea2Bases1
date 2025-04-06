const apiURL = "http://localhost:3000/queries";


window.onload = async () => {
    const response = await fetch(apiURL);
    const employees = await response.json();

};

