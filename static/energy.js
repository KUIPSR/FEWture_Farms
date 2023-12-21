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
    fetch('/calculateEnergy')
        .then(response => response.json())
        .then(data => {
            const farmEnergyProductionData = JSON.parse(data.farm_energy_production_img_data);
            const energyNetCalculationData = JSON.parse(data.energy_net_calc_img_data);

            const farmEnergyProductionTitle = farmEnergyProductionData.energy.farmenergyproductiontitle;
            const energyProductionTitle = energyNetCalculationData.Income.energyproductiontitle;

            const years = farmEnergyProductionData.energy.Year.map(Number);
            const windData = farmEnergyProductionData.energy.Wind ? farmEnergyProductionData.energy.Wind.map(Number): [];
            const solarData = farmEnergyProductionData.energy.Solar ? farmEnergyProductionData.energy.Solar.map(Number): [];
            const zeroMwhData = farmEnergyProductionData.energy.zeroMWh ? farmEnergyProductionData.energy.zeroMWh.map(Number): [];

            const netYears = energyNetCalculationData.Income.Year.map(Number);
            const windIncome = energyNetCalculationData.Income.Wind ? energyNetCalculationData.Income.Wind.map(Number): [];
            const solarIncome = energyNetCalculationData.Income.Solar ? energyNetCalculationData.Income.Solar.map(Number): [];
            const us$0Income = energyNetCalculationData.Income.US$0 ? energyNetCalculationData.Income.US$0.map(Number): [];

            // Create the first Highcharts chart for farmEnergyProduction
            Highcharts.chart('chart1', {
                title: {
                    text: farmEnergyProductionTitle,
                },
                xAxis: {
                    categories: years,
                    title: {
                        text: '<b>Year since the beginning of the simulation</b>',
                    },
                },
                yAxis: {
                    title: {
                        text: '<b>Production</b>',
                    },
                },
                series: [
                    { name: 'Wind', data: windData, color: 'red' },
                    { name: 'Solar', data: solarData, color: 'green' },
                    { name: '0 MWh', data: zeroMwhData, color: 'blue' },
                ],
                // Add exporting options
                exporting: {
                    filename: `EnergyProduction_${getCurrentDateTime()}`,
                    buttons: {
                        contextButton: {
                            menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                        },
                    },
                },
            });

            // Create the second Highcharts chart for energyNetIncomeCalculation
            Highcharts.chart('chart2', {
                title: {
                    text: energyProductionTitle,
                },
                xAxis: {
                    categories: netYears,
                    title: {
                        text: '<b>Year since the beginning of the simulation</b>',
                    },
                },
                yAxis: {
                    title: {
                        text: '<b>Income ($)</b>',
                    },
                },
                series: [
                    { name: 'Wind', data: windIncome, color: 'red' },
                    { name: 'Solar', data: solarIncome, color: 'green' },
                    { name: 'US$', data: us$0Income, color: 'yellow' },
                ],
                // Add exporting options
                exporting: {
                    filename: `EnergyNetIncome_${getCurrentDateTime()}`,
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
