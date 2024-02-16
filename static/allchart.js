// Get Current Timestamp 
function getCurrentDateTime() {
    const months = [
        "Jan","Feb","Mar","Apr","May","Jun",
        "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    const now = new Date();
    const day = now.getDate().toString().padStart(2,'0');
    const month = months[now.getMonth()];
    const year = now.getFullYear();
    const hours = now.getHours().toString().padStart(2,'0');
    const minutes = now.getMinutes().toString().padStart(2,'0');
    const seconds = now.getSeconds().toString().padStart(2,'0');

    const formattedDateTime = `${day}${month}${year} ${hours}:${minutes}:${seconds}`;

    return formattedDateTime;
}



// Agriculture Chart JS
function drawAgricultureCharts() {
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
            title:{
                text: cropProductionTitle,
            },
            xAxis: {
                categories: years,
                title:{
                    text: '<b>Year since the beginning of the simulation</b>'
                },
            },
            yAxis: {
                title:{
                    text:'<b>Production (Bushels)</b>',
                },
            },
            series: [
                { name: 'Corn', data: cornData, color: 'red'},
                { name: 'Wheat', data: wheatData, color: 'green'},
                { name: 'Soybean', data: soybeanData, color: 'blue'},
                { name: 'SG', data: sgData, color: 'orange'}
            ],

            exporting: {
                buttons:{
                    filename: `CropProduction_${getCurrentDateTime()}`,
                    contextButton:{
                        menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
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
                { name: 'Corn', data: cornIncome, color: 'red'},
                { name: 'Wheat', data: wheatIncome, color: 'green'},
                { name: 'Soybean', data: soybeanIncome, color: 'blue'},
                { name: 'SG', data: sgIncome, color: 'orange'},
                { name: 'US$', data: USIncome, color: 'yellow' }
            ],
            // Add exporting options
            exporting: {
                filename: `AgricultureNetIncome_${getCurrentDateTime()}`,
                buttons: {
                    contextButton: {
                        menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                    },
                },
            },
        });


    })
    .catch(error =>{
        console.error('Error:',error)
    });
}


// Water Chart JS

function drawWaterCharts() {
    fetch('/calculateIrrigation')
    .then(response => response.json())
    .then(data => {
        const gwIrrigationData = JSON.parse(data.crop_groundwater_irrigation_data_for_img);
        const gwLevelData = JSON.parse(data.groundwater_level_data_img);

        const CropIrrigationTitle = gwIrrigationData.irrigation.CropIrrigationTitle;
        const GroundWaterLeveltitle = gwLevelData.gw_level.GroundWaterLeveltitle;

        const years = gwIrrigationData.irrigation.Year.map(Number);
        const cornData = gwIrrigationData.irrigation.Corn ? gwIrrigationData.irrigation.Corn.map(Number): [];
        const wheatData = gwIrrigationData.irrigation.Wheat ? gwIrrigationData.irrigation.Wheat.map(Number): [];
        const soybeanData = gwIrrigationData.irrigation.Soybean ? gwIrrigationData.irrigation.Soybean.map(Number): [];
        const sgData = gwIrrigationData.irrigation.SG ? gwIrrigationData.irrigation.SG.map(Number): [];

        const netYears = gwLevelData.gw_level.Year.map(Number);
        const gwLevel = gwLevelData.gw_level.GW_level.map(Number); 
        const minAqLvl = gwLevelData.gw_level.Min_Aq.map(Number);
        const minPlus30 = gwLevelData.gw_level.MinPlus30.map(Number);

        // Create the first Highcharts for cropIrrigationChart

        Highcharts.chart('chart3', {
            title:{
                text: CropIrrigationTitle,
            },
            xAxis: {
                categories: years,
                title:{
                    text: '<b>Year since the beginning of the simulation</b>'
                },
            },
            yAxis: {
                title:{
                    text:'<b>Irrigation</b>',
                },
            },
            series: [
                { name: 'Corn', data: cornData, color: 'red'},
                { name: 'Wheat', data: wheatData, color: 'green'},
                { name: 'Soybean', data: soybeanData, color: 'blue'},
                { name: 'SG', data: sgData, color: 'orange'}
            ],

            exporting: {
                buttons:{
                    filename: `CropIrrigation_${getCurrentDateTime()}`,
                    contextButton:{
                        menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                    },
                },
            },
        });
        // Create the second Highcharts chart for energyNetIncomeCalculation
        Highcharts.chart('chart4', {
            title: {
                text: GroundWaterLeveltitle,
            },
            xAxis: {
                categories: netYears,
                title: {
                    text: '<b>Year since the beginning of the simulation</b>',
                },
            },
            yAxis: {
                title: {
                    text: '<b>GroundWater Level</b>',
                },
            },
            series: [
                { name: 'GW_level', data: gwLevel, color: 'red'},
                { name: 'Min_Aq', data: minAqLvl, color: 'green'},
                { name: 'MinPlus30', data: minPlus30, color: 'blue'}
            ],
            // Add exporting options
            exporting: {
                filename: `GroundWaterLevel_${getCurrentDateTime()}`,
                buttons: {
                    contextButton: {
                        menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                    },
                },
            },
        });


    })
    .catch(error =>{
        console.error('Error:',error)
    });
}

// Energy Charts JS

function drawEnergyCharts() {
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
            Highcharts.chart('chart5', {
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
                    filename: `FramEnergyProduction_${getCurrentDateTime()}`,
                    buttons: {
                        contextButton: {
                            menuItems:["downloadPNG", "downloadJPEG", "downloadPDF", "downloadSVG", "downloadXLS","downloadCSV"],
                        },
                    },
                },
            });

            // Create the second Highcharts chart for energyNetIncomeCalculation
            Highcharts.chart('chart6', {
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

function drawClimateCharts() {
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
            Highcharts.chart('chart7', {
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
            Highcharts.chart('chart8', {
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
                    filename: `TotalIncome_${getCurrentDateTime()}`,
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
document.addEventListener('DOMContentLoaded', () => {
    drawAgricultureCharts();
    drawWaterCharts();
    drawEnergyCharts();
    drawClimateCharts();
});

