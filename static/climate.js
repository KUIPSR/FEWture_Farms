// Generate Current Date and TIme
function getCurrentDateTime() {
    const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    const now = new Date();
    const day = now.getDate().toString().padStart(2, '0');
    const month = months[now.getMonth()];
    const year = now.getFullYear();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');

    const formattedDateTime = `${day}${month}${year} ${hours}:${minutes}:${seconds}`;
    return formattedDateTime;
}




function drawCharts() {
    fetch('/calculateClimate')
        .then(response => response.json())
        .then(data => {
            const getCropIncomeData = JSON.parse(data.crop_income_img);
            const getCropInsuranceData = JSON.parse(data.insur_income_img);

            const cropIncomeTitle = getCropIncomeData.Crop_Income.total_farm_net_income;
            const cropInsuranceTitle = getCropInsuranceData.Insurance_Income.total_income_from_crop_insurance;

            const years = getCropIncomeData.Crop_Income.Year.map(Number);
            const cropData = getCropIncomeData.Crop_Income.Crop ? getCropIncomeData.Crop_Income.Crop.map(Number):[];
            const energyData = getCropIncomeData.Crop_Income.Energy ? getCropIncomeData.Crop_Income.Energy.map(Number):[];
            const allData = getCropIncomeData.Crop_Income.All ? getCropIncomeData.Crop_Income.All.map(Number):[];
            const usData =  getCropIncomeData.Crop_Income.US$0 ? getCropIncomeData.Crop_Income.US$0.map(Number):[];
    
            const year = getCropInsuranceData.Insurance_Income.Year.map(Number);
            const CornData = getCropInsuranceData.Insurance_Income.Corn ? getCropInsuranceData.Insurance_Income.Corn.map(Number):[];
            const WheatData = getCropInsuranceData.Insurance_Income.Wheat ? getCropInsuranceData.Insurance_Income.Wheat.map(Number):[];
            const SoyaData = getCropInsuranceData.Insurance_Income.Soybean ? getCropInsuranceData.Insurance_Income.Soybean.map(Number):[];
            const getsgData = getCropInsuranceData.Insurance_Income.SG ? getCropInsuranceData.Insurance_Income.SG.map(Number):[];

            // Create the first Highcharts chart for farmEnergyProduction
            Highcharts.chart('chart1', {
                title: {
                    text: cropIncomeTitle,

                },
                xAxis: {
                    categories: years,
                    title: {
                        text: '<b>Year since the beginning of the simulation</b>',
                    },
                },
                yAxis: {
                    title: {
                        text: '<b>Total Net Income ($) </b>',
                    },
                },
                series: [
                    { name: 'Crop', data: cropData, color: 'red'},
                    { name: 'Energy', data: energyData, color: 'green'},
                    { name: 'All', data: allData, color: 'blue'},
                    { name: 'US$', data: usData, color: 'orange'}
                ],
                // Add exporting options
                exporting: {
                    filename: `TotalFarmNetIncome_${getCurrentDateTime()}`,
                    buttons: {
                        contextButton: {
                            menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                        },
                    },
                },
            });

            // Create the second Highcharts chart for energyNetIncomeCalculation
            Highcharts.chart('chart2', {
                chart: {
                    type: 'scatter', 
                },
                title: {
                    text: cropInsuranceTitle,
                },
                xAxis: {
                    categories: year,
                    title: {
                        text: '<b>Year since the beginning of the simulation</b>',
                    },
                },
                yAxis: {
                    title: {
                        text: '<b>Income from Crop Insurance ($)</b>',
                    },
                },
                series: [
                    { name: 'Corn', data: CornData, color: 'red'},
                    { name: 'Wheat', data: WheatData, color: 'green'},
                    { name: 'Soyabean', data: SoyaData, color: 'blue'},
                    { name: 'SG', data: getsgData, color: 'yellow'}
                ],
                // Add exporting options
                exporting: {
                    filename: `TotalIncomeFromCropInsurance_${getCurrentDateTime()}`,
                    buttons: {
                        contextButton: {
                            menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                        },
                    },
                },
            });
        })
        .catch(error => {
            console.error('Error:', error);
        });
}

// Call the drawCharts function when the page loads
document.addEventListener('DOMContentLoaded', drawCharts);
