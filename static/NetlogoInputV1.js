const slider = document.getElementById("num_of_years");
const sliderValue = document.getElementById("slider-value");
const iframe = document.querySelector('iframe');
const loader = document.getElementById("loader");


function showLoader() {
    var loader = document.getElementById('loader');
    var body = document.querySelector('body');
    
    if (loader) {
      loader.style.display = 'block';
      body.classList.add('blur');
    }
  }

  // Function to hide the loader and remove the blur
function hideLoader() {
    var loader = document.getElementById('loader');
    var body = document.querySelector('body');
    
    if (loader) {
      loader.style.display = 'none';
      body.classList.remove('blur');
    }
  }

// Hide the iframe by default
// iframe.style.display = 'none';

slider.addEventListener("input", () => {
    sliderValue.textContent = "Numbers of Years Selected :: " + slider.value;
});

function combineFormData(formId) {
    const form = document.getElementById(formId);
    const formData = new FormData(form);
    const data = {};

    for (const [key, value] of formData.entries()) {
        data[key] = value;
    }

    return data;
}

function combineAllFormData() {
    const agricultureData = combineFormData('AgricultureForm');
    const energyData = combineFormData('EnergyForm');
    const irrigationData = combineFormData('IrrigationForm');
    const ClimateData = combineFormData('climateForm');

    const numberOfYearsData = {
        num_of_years: slider.value
    };

    const startOfYearsData = {
        input_start_of_years: document.getElementById("input_start_of_years").value
    };



    const combinedData = {
        agriculture: agricultureData,
        energy: energyData,
        irrigation: irrigationData,
        numberofyears: numberOfYearsData,
        ClimateData:ClimateData,
        StartYear:startOfYearsData
    };

    return combinedData;
}

const calculateButton = document.getElementById("calculate-button");

calculateButton.addEventListener("click", function (event) {
    event.preventDefault(); // Prevent the default form submission
    const formData = combineAllFormData();

    showLoader()


    // Send the data to your Python API using Fetch
    fetch('/calculate', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
    })
    .then(response => response.json())
    .then(data => {
        console.log('Response from API:', data);
        alert("Data Calculated Successfully !!")
        hideLoader()
    })
    .catch(error => {
        alert('Error:', error);
        hideLoader()
    });
});
