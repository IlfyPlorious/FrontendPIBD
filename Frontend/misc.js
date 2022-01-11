function toggle(){
    var selectProdus = document.getElementById('produsSelect');
    var medicament = selectProdus.options[selectProdus.selectedIndex].value,
        suma = document.getElementById('suma');
        cantitate = document.getElementById('cantitate');
        sumaDB = document.getElementById('sumaDB');

    if (medicament === 'paracetamol') {
        suma.textContent = 4 * cantitate.value;
        sumaDB.value = 4 * cantitate.value;
    } else if (medicament === 'nurofen') {
        suma.textContent = 8 * cantitate.value;
        sumaDB.value = 8 * cantitate.value;
    } else if (medicament === 'furazolidon') {
        suma.textContent = 5 * cantitate.value;
        sumaDB.value = 8 * cantitate.value;
    } else if (medicament === 'clotrimazol') {
        suma.textContent = 15 * cantitate.value;
        sumaDB.value = 8 * cantitate.value;
    } else if (medicament === 'kerium') {
        suma.textContent = 50 * cantitate.value;
        sumaDB.value = 8 * cantitate.value;
    }
}