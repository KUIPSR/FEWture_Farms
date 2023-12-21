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
    fetch('/calculateAgriculture')
        .then(response => response.json())
        .then(data => {
            const cropProductionData = JSON.parse(data.crop_production_img);
            const netCalculationData = JSON.parse(data.net_calc_img);

            const cropProductionTitle = cropProductionData.production.crop_production_title;
            const netCalculationTitle = netCalculationData.Income.netCalculationTitle;

            const years = cropProductionData.production.Year.map(Number);
            const cornData = cropProductionData.production.Corn ? cropProductionData.production.Corn.map(Number): [];
            const wheatData = cropProductionData.production.Wheat ? cropProductionData.production.Wheat.map(Number): [];
            const soybeanData = cropProductionData.production.Soybean ? cropProductionData.production.Soybean.map(Number): [];
            const sgData = cropProductionData.production.SG ? cropProductionData.production.SG.map(Number) : [];

            const netYears = netCalculationData.Income.Year.map(Number);
            const cornIncome = netCalculationData.Income.Corn ? netCalculationData.Income.Corn.map(Number): [];
            const wheatIncome = netCalculationData.Income.Wheat ? netCalculationData.Income.Wheat.map(Number): [];
            const soybeanIncome = netCalculationData.Income.Soybean ? netCalculationData.Income.Soybean.map(Number): [];
            const sgIncome = netCalculationData.Income.SG ? netCalculationData.Income.SG.map(Number): [];
            const USIncome = netCalculationData.Income.US$0 ? netCalculationData.Income.US$0.map(Number): [];



            // Create the first Highcharts for cropProductionChart
            Highcharts.chart('chart1', {
                title: {
                    text: cropProductionTitle,
                },
                xAxis: {
                    categories: years,
                    title: {
                        text: '<b>Year since the beginning of the simulation</b>'
                    },
                },
                yAxis: {
                    title: {
                        text: '<b>Production (Bushels)</b>',
                    },
                },
                series: [
                    { name: 'Corn', data: cornData, color: 'red' },
                    { name: 'Wheat', data: wheatData, color: 'green' },
                    { name: 'Soybean', data: soybeanData, color: 'blue' },
                    { name: 'SG', data: sgData, color: 'orange' }
                ],
                exporting: {
                    filename: `CropProduction_${getCurrentDateTime()}`,
                    buttons: {
                        contextButton: {
                            menuItems: ["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS", "downloadCSV"],
                        },
                    },
                },
            });

            // Create the second Highcharts chart for energyNetIncomeCalculation
            Highcharts.chart('chart2', {
                title: {
                    text: netCalculationTitle,
                },
                xAxis: {
                    categories: netYears,
                    title: {
                        text: '<b>Year since the beginning of the simulation</b>',
                    },
                },
                yAxis: {
                    title: {
                        text: '<b> Income ($) </b>',
                    },
                },
                series: [
                    { name: 'Corn', data: cornIncome, color: 'red' },
                    { name: 'Wheat', data: wheatIncome, color: 'green' },
                    { name: 'Soybean', data: soybeanIncome, color: 'blue' },
                    { name: 'SG', data: sgIncome, color: 'orange' },
                    { name: 'US$', data: USIncome, color: 'yellow' }
                ],
                exporting: {
                    filename: `AgricultureNetIncome_${getCurrentDateTime()}`,
                    buttons: {
                        contextButton: {
                            menuItems: ["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS", "downloadCSV"],
                        },
                    },
                },
            });
        })
        .catch(error => {
            console.error('Error:', error)
        });
}

// Call the drawCharts function when the page loads
document.addEventListener('DOMContentLoaded', drawCharts);
